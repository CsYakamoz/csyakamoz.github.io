---
title: "RabbitMQ 交换机类型"
date: 2020-09-09T16:38:46+08:00
tags: ["rabbitmq"]
---

RabbitMQ 的交换机共有四种类型。

- fanout - 扇形
- direct - 直连
- topic - 主题
- headers - 头（尚未了解，此文不说明）

```javascript
/**
 * 发布消息到指定交换机
 * @param {string} exchange - 交换机名
 * @param {string} routingKey - 该消息的路由键
 * @param {string} content - 消息内容
 */
channel.publish(exchange, routingKey, content);

/**
 * 将队列与交换机进行绑定
 * @param {string} queue - 队列名
 * @param {string} exchange - 交换机名
 * @param {string} bindingKey - 绑定路由
 */
change.bindQueue(queue, exchange, bindingKey);
```

## fanout

fanout 翻译成扇形，如同其外形，该类型交换机只是将接收到的所有消息广播给与它绑定的所有队列

对于 fanout 交换机，`publish` 会无视 `routingKey` 参数，`bindQueue` 会无视 `bindingKey` 参数

![exchanges.png](https://www.rabbitmq.com/img/tutorials/exchanges.png)

X 会将收到的消息，无条件转发到所有与其绑定的队列

## direct

该类型交换机将会对绑定路由 (bindingKey) 和路由键 (routingKey) 进行精确匹配，从而确定消息该分发到哪个队列

![direct-exchange.png](https://www.rabbitmq.com/img/tutorials/direct-exchange.png)

X 有两个队列与其绑定，Q1 用 `orange` 绑定，Q2 则同时用 `black`, `green` 绑定

此时，所有发送到 X 交换机的消息有以下四种结果：

1. 路由键为 `orange` 的消息转发到 Q1
2. 路由键为 `black` 的消息转发到 Q2
3. 路由键为 `green` 的消息转发到 Q2
4. 路由键为其它的消息则丢弃，因为没有满足条件的队列

![direct-exchange-multiple.png](https://www.rabbitmq.com/img/tutorials/direct-exchange-multiple.png)

多个队列使用相同的绑定键是合法的。

图例中，X 与 Q1 的绑定路由为 `black`, X 与 Q2 的绑定路由也为 `black`

路由键为 `black` 的消息会同时转发到 Q1 和 Q2 中

## topic

topic 与 direct 类似，也是对绑定路由 (bindingKey) 和路由键 (routingKey) 进行匹配，但可支持模式匹配

RabbitMQ 的模式有两个特殊字符：

- `*` 代表一个单词 (word)
- `#` 代表零个或多个单词 (word)

![python-five](https://www.rabbitmq.com/img/tutorials/python-five.png)

X 与 Q1 的绑定路由为 `*.orange.*`, X 与 Q2 的绑定路由为 `*.*.rabbit` 和 `lazy.#`

1. 路由键为 `quick.orange.rabbit` 的消息转发到 Q1 和 Q2
2. 路由键为 `lazy.orange.elephant` 的消息转发到 Q1 和 Q2
3. 路由键为 `quick.orange.fox` 的消息转发到 Q1
4. 路由键为 `lazy.brown.fox` 的消息转发到 Q2
5. 路由键为 `lazy.pink.rabbit` 的消息仅转发一次到 Q2, 尽管它同时满足 `*.*.rabbit` 和 `lazy.#`
6. 路由键为 `quick.brown.fox` 的消息丢弃

topic 交换机非常强大，因为它也可以实现 fanout, direct 的功能

- 当绑定路由为 `#` 时，它表现行为与 fanout 一样
- 当绑定路由不包含 `*` 和 `#` 时，它表现行为与 direct 一样
