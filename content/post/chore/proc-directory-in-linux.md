---
title: "Proc Directory in Linux"
date: 2023-12-21T00:53:45+08:00
tags: ["unix"]
draft: true
---

背景:

线上的某个 `crontab` 命令执行不成功, 查看日志后发现是无法加载配置文件(文件路径为相对路径), 因此执行失败.

当时我第一反应就是工作目录不正确, 但是同事当时说了句去看 `/proc`, 当时不懂, 但也没关注这个.

虽然后续我用其他办法证明了工作目录的确是错误, 但因此我对 `/proc` 目录留了个印象, 因此专门查了下资料, 并记录下.
