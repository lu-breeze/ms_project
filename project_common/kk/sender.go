package kk

import (
	"context"
	"errors"
	"github.com/segmentio/kafka-go"
	"log"
	"time"
)

type LogData struct {
	Topic string
	Data  []byte //传入json
}

type KafkaWriter struct {
	w    *kafka.Writer
	Data chan LogData
}

func (w *KafkaWriter) Close() {
	if w.w != nil {
		w.w.Close()
	}
}

func GetWriter(addr string) *KafkaWriter {
	w := &kafka.Writer{
		Addr:     kafka.TCP(addr),
		Balancer: &kafka.LeastBytes{},
	}
	k := &KafkaWriter{w: w, Data: make(chan LogData, 100)}
	go k.sendMsg()
	return k
}

func (kw *KafkaWriter) Send(data LogData) {
	kw.Data <- data
}

func (kw *KafkaWriter) sendMsg() {
	for {
		select {
		case data := <-kw.Data:
			msg := []kafka.Message{
				{
					Topic: data.Topic,
					Key:   []byte("logMsg"),
					Value: data.Data,
				},
			}
			var err error
			const retries = 3
			ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
			defer cancel()
			for i := 0; i < retries; i++ {
				err = kw.w.WriteMessages(ctx, msg...)
				if err == nil {
					break
				}
				if errors.Is(err, kafka.LeaderNotAvailable) || errors.Is(err, context.DeadlineExceeded) {
					time.Sleep(time.Millisecond * 250)
					continue
				}
				if err != nil {
					log.Println("kafka send log writer msg err", err.Error())
				}
			}

		}
	}
}
