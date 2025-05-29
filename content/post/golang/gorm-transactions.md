---
title: "GORM Transactions"
date: 2024-10-03T10:02:30+08:00
tags: ["golang", "gorm"]
---

# 前置知识

## GORM DB 对象

## `*gorm.DB` 可只初始化一次

> 参考信息:
>
> - [Question on pooling/concurrency regarding recent documentation change, suggest clarification #1053](https://github.com/go-gorm/gorm/issues/1053)
> - [Does gorm.Open() create a new connection pool every time it's called?](https://stackoverflow.com/questions/61822921/does-gorm-open-create-a-new-connection-pool-every-time-its-called)

[database/sql.Open](https://pkg.go.dev/database/sql#Open) 也提到:

> The returned DB is safe for concurrent use by multiple goroutines and maintains its own pool of idle connections. Thus, the Open function should be called just once. It is rarely necessary to close a DB.

## GORM 如何开启事务

> 官方文档: [Transactions](https://gorm.io/docs/transactions.html) and [Gen Transactions](https://gorm.io/gen/transaction.html)

## 代码分层

个人在编写业务代码时, 业务分层大概如下:

`controller`/`entrance`/`handler` -> `biz`/`service` -> `dao`/`repo(sitory)` -> `model`

- `biz` 层用于业务编排

  若需要开启事务, 则在 `biz` 层开启事务, 然后调用 `repo` 层

- `repo` 层用于封装存储层的操作, 代码大概如下:

  ```go
  import (
  	"context"

  	"gorm.io/gorm"
  )

  type Model struct{}

  type ModelRepo struct{}

  func NewModelRepo() ModelRepo {
  	return ModelRepo{}
  }

  func (r ModelRepo) Get(ctx context.Context, id uint32) (*Model, error) {
  	// logic...
  	return &Model{}, nil
  }

  func (r ModelRepo) Create(ctx context.Context, data *Model) error {
  	// logic...
  	return nil
  }
  ```

# 发展过程

## 无状态的 Repo

一开始仅需要简单的 `Create` 的方法, 但后面发现存在场景需要在事务中执行该方法

然而接触 Golang 的时间不久, 加上业务紧张, 就临时决定按如下做:

```go
func (r ModelRepo) CreateWithTx(
	ctx context.Context,
	tx *gorm.DB,
	data *Model,
) error {
	// logic...
	return nil
}
```

不需要在事务中创建对象时, 则调用 `Create` 方法, 需要时则调用 `CreateWithTx` 方法.

## 参考他人代码 - 有状态的 repo

## 最终版

> ref: [大家做 go 后端开发时，都是怎么处理接口操作的原子性的？](https://s.v2ex.com/t/1021397)
