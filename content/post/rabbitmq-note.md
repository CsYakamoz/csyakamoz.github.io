---
title: "RabbitMQ 笔记"
date: 2020-09-09T16:35:55+08:00
tags: ["rabbitmq"]
---

[RabbitMQ 官方教程](https://www.rabbitmq.com/getstarted.html)

## 名词

生产者 (Producing): 发送消息到交换机

路由键 (Routing Key): 消息属性，由生产者在发送消息时声明

交换机 (Exchange): 接受来自生产者的消息，并将消息分发给满足条件的队列

绑定路由 (Binding Key): 用于绑定交换机与队列

队列 (Queue): 消息存储的地方；接受来自交换机的消息，并在存有消费者的情况下，将消息发给消费者

消费者 (Consuming): 从队列中接收消息，并做对应的处理

## 消息传递流程

生产者 -> 交换机 -> 队列 -> 消费者

- 生产者的每个消息只能发给一个交换机；生成者发送的时候，可指定该消息的路由键

- 交换机每收到一个消息，则将该消息发送给满足条件的队列；若没有队列满足条件，则丢弃该消息

  交换机是否转发给队列，由交换机类型，交换机队列的绑定路由共同决定

  交换机可以跟多个队列使用绑定路由，也可以跟同个队列绑定不同的绑定路由

- 队列收到消息后，会存储该消息，直到有消费者订阅该队列

## 代码样例

```javascript
// Producing

const amqp = require("amqplib");

const ExchangeName = "exchange-name";
const ExchangeType = "exchange-type"; // fanout | direct | topic | headers

const MsgRoutingKey = "msg-routing-key";

(async () => {
  const connection = await amqp.connect("amqp://127.0.0.1:5672");
  const channel = await connection.createChannel();

  // 创建交换机
  await channel.assertExchange(ExchangeName, ExchangeType);

  // 发布消息到指定交换机
  channel.publish(ExchangeName, MsgRoutingKey, Buffer.from("Hello, World."));
})().catch((e) => console.log(e));
```

```javascript
// Consuming

const amqp = require("amqplib");

const ExchangeName = "exchange-name";
const ExchangeType = "exchange-type"; // fanout | direct | topic | headers

const QueueName = "queue-name";

const BindingKey = "binding-key";

(async () => {
  const connection = await amqp.connect("amqp://127.0.0.1:5672");
  const channel = await connection.createChannel();

  // 创建交换机
  await channel.assertExchange(ExchangeName, ExchangeType);

  // 创建队列
  await channel.assertQueue(QueueName);

  // 将交换机与队列进行绑定
  await channel.bindQueue(QueueName, ExchangeName, BindingKey);

  // 监听队列，并指定处理函数
  await channel.consume(QueueName, (msg) => {
    console.log(msg.content.toString());
  });
})().catch((e) => console.log(e));
```
