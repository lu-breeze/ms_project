package login_service_v1

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/jinzhu/copier"
	"github.com/redis/go-redis/v9"
	"go.uber.org/zap"
	common "go_project/ms_project/project_common"
	"go_project/ms_project/project_common/encrypts"
	"go_project/ms_project/project_common/errs"
	"go_project/ms_project/project_common/jwts"
	"go_project/ms_project/project_common/tms"
	"go_project/ms_project/project_grpc/user/login"
	"go_project/ms_project/project_user/config"
	"go_project/ms_project/project_user/internal/dao"
	"go_project/ms_project/project_user/internal/data/member"
	"go_project/ms_project/project_user/internal/data/organization"
	"go_project/ms_project/project_user/internal/database"
	"go_project/ms_project/project_user/internal/database/tran"
	"go_project/ms_project/project_user/internal/repo"
	"go_project/ms_project/project_user/pkg/model"
	"log"
	"strconv"
	"strings"
	"time"
)

type LoginService struct {
	login.UnimplementedLoginServiceServer
	cache            repo.Cache
	memberRepo       repo.MemberRepo
	organizationRepo repo.OrganizationRepo
	transaction      tran.Transaction
}

func New() *LoginService {
	return &LoginService{
		cache:            dao.Rc,
		memberRepo:       dao.NewMemberDao(),
		organizationRepo: dao.NewOrganizationDao(),
		transaction:      dao.NewTransaction(),
	}
}

func (ls *LoginService) GetCaptcha(ctx context.Context, msg *login.CaptchaMessage) (*login.CaptchaResponse, error) {
	//1.获取参数
	mobile := msg.Mobile
	//2.校验参数
	if !common.VerifyMobile(mobile) {
		return nil, errs.GrpcError(model.NoLegalMobile)
	}
	//3.生成四位或者六位验证码
	code := "123456"
	//4.调用短信平台
	go func() {
		time.Sleep(2 * time.Second)
		zap.L().Info("短信平台调用成功，发送短信")
		//5.存储验证码到redis，过期时间为15分钟
		c, cancel := context.WithTimeout(context.Background(), 2*time.Second)
		defer cancel()
		if err := ls.cache.Put(c, model.RegisterRedisKey+mobile, code, 15*time.Minute); err != nil {
			log.Printf("存储验证码到redis失败，手机号：%s，错误：%v", mobile, err)
		} else {
			log.Printf("存储验证码到redis成功，手机号：%s，验证码：%s", mobile, code)
		}
	}()
	return &login.CaptchaResponse{Code: code}, nil
}

func (ls *LoginService) Register(ctx context.Context, msg *login.RegisterMessage) (*login.RegisterResponse, error) {
	c := context.Background()
	//校验验证码
	redisCode, err := ls.cache.Get(c, model.RegisterRedisKey+msg.Mobile)
	//TODO redis修正
	if err == redis.Nil {
		return nil, errs.GrpcError(model.CaptchaNotExist)
	}
	if err != nil {
		zap.L().Error("Register从redis获取验证码失败", zap.Error(err))
		return nil, errs.GrpcError(model.RedisError)
	}
	if redisCode != msg.Captcha {
		return nil, errs.GrpcError(model.CaptchaError)
	}
	//校验业务逻辑数据是否冲突
	exist, err := ls.memberRepo.GetMemberByEmail(c, msg.Email)
	if err != nil {
		zap.L().Error("Register从db获取用户信息失败", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	if exist {
		return nil, errs.GrpcError(model.EmailExist)
	}

	exist, err = ls.memberRepo.GetMemberByAccount(c, msg.Name)
	if err != nil {
		zap.L().Error("Register从db获取用户信息失败", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	if exist {
		return nil, errs.GrpcError(model.AccountExist)
	}

	exist, err = ls.memberRepo.GetMemberByMobile(c, msg.Mobile)
	if err != nil {
		zap.L().Error("Register从db获取用户信息失败", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	if exist {
		return nil, errs.GrpcError(model.MobileExist)
	}
	//将数据存入member表
	pwd := encrypts.Md5(msg.Password)
	mem := &member.Member{
		Account:       msg.Name,
		Password:      pwd,
		Name:          msg.Name,
		Mobile:        msg.Mobile,
		Email:         msg.Email,
		CreateTime:    time.Now().UnixMilli(),
		LastLoginTime: time.Now().UnixMilli(),
		Status:        model.Normal,
	}
	err = ls.transaction.Action(func(conn database.DbConn) error {
		err = ls.memberRepo.SaveMember(conn, c, mem)
		if err != nil {
			zap.L().Error("Register向db存储用户信息失败", zap.Error(err))
			return errs.GrpcError(model.DBError)
		}
		//将数据存入organization表
		org := &organization.Organization{
			Name:       mem.Name + "个人组织",
			MemberId:   mem.Id,
			CreateTime: time.Now().UnixMilli(),
			Personal:   model.Personal,
			Avatar:     "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.dtstatic.com%2Fuploads%2Fblog%2F202103%2F31%2F20210331160001_9a852.thumb.1000_0.jpg&refer=http%3A%2F%2Fc-ssl.dtstatic.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673017724&t=ced22fc74624e6940fd6a89a21d30cc5",
		}
		err = ls.organizationRepo.SaveOrganization(conn, c, org)
		if err != nil {
			zap.L().Error("register SaveOrganization db err", zap.Error(err))
			return model.DBError
		}
		return nil
	})
	//TODO 生成一个账户，账户的授权角色是默认
	return &login.RegisterResponse{}, err
}

func (ls *LoginService) Login(ctx context.Context, msg *login.LoginMessage) (*login.LoginResponse, error) {
	c := context.Background()
	//从数据库获取用户信息
	pwd := encrypts.Md5(msg.Password)
	mem, err := ls.memberRepo.FindMember(c, msg.Account, pwd)
	if err != nil {
		zap.L().Error("Login向db查询用户信息失败", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	if mem == nil {
		return nil, errs.GrpcError(model.AccountOrPwdError)
	}
	memMsg := &login.MemberMessage{}
	err = copier.Copy(memMsg, mem)
	memMsg.Code, _ = encrypts.EncryptInt64(memMsg.Id, model.AESKey)
	memMsg.LastLoginTime = tms.FormatByMill(mem.LastLoginTime)
	memMsg.CreateTime = tms.FormatByMill(mem.CreateTime)
	//根据id查询组织
	orgs, err := ls.organizationRepo.FindOrganizationByMemId(c, mem.Id)
	if err != nil {
		zap.L().Error("Login向db查询用户信息失败", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	var orgsMessage []*login.OrganizationMessage
	err = copier.Copy(&orgsMessage, orgs)
	for _, v := range orgsMessage {
		v.Code, _ = encrypts.EncryptInt64(v.Id, model.AESKey)
		v.OwnerCode = memMsg.Code
		o := organization.ToMap(orgs)[v.Id]
		v.CreateTime = tms.FormatByMill(o.CreateTime)
	}
	if len(orgs) > 0 {
		memMsg.OrganizationCode, _ = encrypts.EncryptInt64(orgs[0].Id, model.AESKey)
	}
	//jwt生成token
	memIdStr := strconv.FormatInt(mem.Id, 10)
	exp := time.Duration(config.C.JwtConfig.AccessExp*3600*24) * time.Second
	rExp := time.Duration(config.C.JwtConfig.RefreshExp*3600*24) * time.Second
	token := jwts.CreateToken(memIdStr, exp, config.C.JwtConfig.AccessSecret, rExp, config.C.JwtConfig.RefreshSecret, msg.Ip)
	//给token加密

	tokenList := &login.TokenMessage{
		AccessToken:    token.AccessToken,
		RefreshToken:   token.RefreshToken,
		AccessTokenExp: token.AccessExp,
		TokenType:      "bearer",
	}
	//member orgs放入缓存
	go func() {
		marshal, _ := json.Marshal(mem)
		ls.cache.Put(c, model.Member+"::"+memIdStr, string(marshal), exp)
		orgsJson, _ := json.Marshal(orgs)
		ls.cache.Put(c, model.MemberOrganization+"::"+memIdStr, string(orgsJson), exp)
	}()
	return &login.LoginResponse{
		Member:           memMsg,
		OrganizationList: orgsMessage,
		TokenList:        tokenList,
	}, nil
}

func (ls *LoginService) TokenVerify(ctx context.Context, msg *login.LoginMessage) (*login.LoginResponse, error) {
	token := msg.Token
	if strings.Contains(token, "bearer ") {
		token = strings.ReplaceAll(token, "bearer ", "")
	}
	parseToken, err := jwts.ParseToken(token, config.C.JwtConfig.AccessSecret, msg.Ip)
	if err != nil {
		zap.L().Error("TokenVerify解析token失败", zap.Error(err))
		return nil, errs.GrpcError(model.NoLogin)
	}
	//缓存中查询id
	memJson, err := ls.cache.Get(context.Background(), model.Member+"::"+parseToken)
	if err != nil {
		zap.L().Error("TokenVerify从缓存获取用户信息失败", zap.Error(err))
		return nil, errs.GrpcError(model.NoLogin)
	}
	if memJson == "" {
		zap.L().Error("TokenVerify缓存中用户信息已过期")
		return nil, errs.GrpcError(model.NoLogin)
	}
	memberById := &member.Member{}
	json.Unmarshal([]byte(memJson), memberById)
	//数据库查询id
	/*id, _ := strconv.ParseInt(parseToken, 10, 64)
	//memberById, err := ls.memberRepo.FindMemberById(context.Background(), id)
	//if err != nil {
	//	zap.L().Error("TokenVerify向db查询用户信息失败", zap.Error(err))
	//	return nil, errs.GrpcError(model.DBError)
	}*/
	memMsg := &login.MemberMessage{}
	copier.Copy(memMsg, memberById)
	memMsg.Code, _ = encrypts.EncryptInt64(memMsg.Id, model.AESKey)

	orgsJson, err := ls.cache.Get(context.Background(), model.MemberOrganization+"::"+parseToken)
	if err != nil {
		zap.L().Error("TokenVerify从缓存获取用户组织信息失败", zap.Error(err))
		return nil, errs.GrpcError(model.NoLogin)
	}
	if orgsJson == "" {
		zap.L().Error("TokenVerify缓存中用户组织信息已过期")
		return nil, errs.GrpcError(model.NoLogin)
	}
	var orgs []*organization.Organization
	json.Unmarshal([]byte(orgsJson), &orgs)

	if len(orgs) > 0 {
		memMsg.OrganizationCode, _ = encrypts.EncryptInt64(orgs[0].Id, model.AESKey)
	}
	memMsg.CreateTime = tms.FormatByMill(memberById.CreateTime)
	return &login.LoginResponse{Member: memMsg}, nil
}

func (l *LoginService) MyOrgList(ctx context.Context, msg *login.UserMessage) (*login.OrgListResponse, error) {
	fmt.Println("MyOrgList")
	memId := msg.MemId
	orgs, err := l.organizationRepo.FindOrganizationByMemId(ctx, memId)
	if err != nil {
		zap.L().Error("MyOrgList FindOrganizationByMemId err", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	var orgsMessage []*login.OrganizationMessage
	err = copier.Copy(&orgsMessage, orgs)
	for _, org := range orgsMessage {
		org.Code, _ = encrypts.EncryptInt64(org.Id, model.AESKey)
	}
	return &login.OrgListResponse{OrganizationList: orgsMessage}, nil
}

func (ls *LoginService) FindMemInfoById(ctx context.Context, msg *login.UserMessage) (*login.MemberMessage, error) {
	memberById, err := ls.memberRepo.FindMemberById(context.Background(), msg.MemId)
	if err != nil {
		zap.L().Error("FindMemInfoById向db查询用户信息失败", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	memMsg := &login.MemberMessage{}
	copier.Copy(memMsg, memberById)
	memMsg.Code, _ = encrypts.EncryptInt64(memMsg.Id, model.AESKey)
	orgs, err := ls.organizationRepo.FindOrganizationByMemId(context.Background(), memberById.Id)
	if err != nil {
		zap.L().Error("FindMemInfoById向db查询用户信息失败", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	if len(orgs) > 0 {
		memMsg.OrganizationCode, _ = encrypts.EncryptInt64(orgs[0].Id, model.AESKey)
	}
	memMsg.CreateTime = tms.FormatByMill(memberById.CreateTime)
	memMsg.Code = encrypts.EncryptNoErr(memMsg.Id)
	return memMsg, nil
}

func (ls *LoginService) FindMemInfoByIds(ctx context.Context, msg *login.UserMessage) (*login.MemberMessageList, error) {
	memberList, err := ls.memberRepo.FindMemberByIds(context.Background(), msg.MIds)
	if err != nil {
		zap.L().Error("FindMemInfoByIds向db查询用户信息失败", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	if memberList == nil || len(memberList) <= 0 {
		return &login.MemberMessageList{List: nil}, nil
	}
	mMap := make(map[int64]*member.Member)
	for _, v := range memberList {
		mMap[v.Id] = v
	}
	var memMsgs []*login.MemberMessage
	copier.Copy(&memMsgs, memberList)
	for _, v := range memMsgs {
		m := mMap[v.Id]
		v.CreateTime = tms.FormatByMill(m.CreateTime)
		v.Code = encrypts.EncryptNoErr(v.Id)
	}

	return &login.MemberMessageList{List: memMsgs}, nil
}
