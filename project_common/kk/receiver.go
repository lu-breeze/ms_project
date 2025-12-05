package kk

import (
	"context"
	"fmt"
	"github.com/segmentio/kafka-go"
	"log"
)

type KafkaReader struct {
	r *kafka.Reader
}

func (r *KafkaReader) readMsg() {
	for {
		m, err := r.r.ReadMessage(context.Background())
		if err != nil {
			log.Println("kafka receiver read msg err", err.Error())
			continue
		}
		fmt.Printf("message at topic/partition/offset %v/%v/%v: %s = %s \n",
			m.Topic, m.Partition, m.Offset, string(m.Key), string(m.Value))
	}
}

func GetReader(brokers []string, groupId, topic string) *KafkaReader {
	r := kafka.NewReader(kafka.ReaderConfig{
		Brokers:  brokers,
		GroupID:  groupId,
		Topic:    topic,
		MinBytes: 10e3,
		MaxBytes: 10e6,
	})
	k := &KafkaReader{
		r: r,
	}
	go k.readMsg()
	return k
}
