---
title: "Crontab"
date: 2023-03-11T11:58:09+08:00
tags: ["shell", "crontab"]
---

> 推荐网站: [Crontab.guru](https://crontab.guru/)

# Mark

- 指定环境变量: `name = value`, `=` 左右两边的空格是可选的
  > 由于空格是可选的, 如想保留 leading/trailing 空格, 请使用单引号或双引号
- 默认 Shell 是 `/bin/sh`, 可通过 `SHELL` 变量指定
- 默认时区是本机时区, 也可通过 `CRON_TZ` 变量指定, 也可通过 `env` 命令为单个命令制定
  > [how to use TimeZone with Cron tab](https://serverfault.com/questions/848829/how-to-use-timezone-with-cron-tab)

# 踩坑

## `%` 字符有着特殊性

在 `crontab` 命令中, `%` 是个特殊符号

参考 [`man crontab`](https://linux.die.net/man/5/crontab):

> The "sixth" field (the rest of the line) specifies the command to be run.
> The entire command portion of the line, up to a newline or % character, will be executed by /bin/sh or by the shell specified in the SHELL variable of the cronfile.
> _Percent-signs (%) in the command, unless escaped with backslash (\\), will be changed into newline characters_, and all data after the first % will be sent to the command as standard input.

具体用例可参考:

- [How do you set a DATE variable to use in a log for crontab output?](https://serverfault.com/questions/339814/how-do-you-set-a-date-variable-to-use-in-a-log-for-crontab-output)
- [How can I execute `date` inside of a cron tab job?](https://unix.stackexchange.com/questions/29578/how-can-i-execute-date-inside-of-a-cron-tab-job)
