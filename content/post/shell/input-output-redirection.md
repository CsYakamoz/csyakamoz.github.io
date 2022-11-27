---
title: "Shell 输入/输出重定向"
date: 2022-11-27T23:15:09+08:00
tags: ["shell"]
---

## Input/Output Redirection

> 输入/输出重定向

### 标准输入/输出/错误输出

| 文件描述符 |            说明             |
| :--------: | :-------------------------: |
|     0      |     输入文件 - 标准输入     |
|     1      |     输出文件 - 标准输出     |
|     2      | 错误输出文件 - 标准错误输出 |

### <, \>

`<` 是输入重定向

`>` 是输出重定向

### < filename

输入从 filename 中读取

### <&N

N 是一个文件描述符

输入从 N 中读取

### [M]\> filename

> Warning: M 和 > 之间不能有空格

M 是一个文件描述符，省略则默认是 1

将 M 的输出重定向到 filename, 若 filename 不存在，则创建，否则覆盖

### [M]\>\> filename

> Warning: M 和 > 之间不能有空格

M 是一个文件描述符，省略则默认是 1

将 M 的输出重定向到 filename; 若 filename 不存在，则创建，否则追加到 N 的最后

### [M]\>&N

> Warning: M 和 > 之间不能有空格

M 是一个文件描述符，省略则默认是 1

N 是另外一个文件描述符

即将 M 的输出重定向到 N

### 样例

```sh
# command 的标准输出重定向到 filename
command > filename
# or
command 1> filename

# command 的标准输出重定向到 filename（追加形式）
command >> filename
# or
command 1>> filename

# command 的标准输出重定向到 filename, 同时标准错误也重定向到标准输出
command > filename 2>&1

# command 的输出重定向到 /dev/null, 相当于禁止输出的效果
command > /dev/null

# 屏蔽 command 的输出以及错误输出
command > /dev/null 2>&1
```

### 为何 `2>&1` 要写在后面？

内容来源：[linux shell 中 "2>&1" 含义](https://www.cnblogs.com/caolisong/archive/2007/04/25/726896.html)

对于 `command > filename 2>&1`

command > filename, 将标准输出重定向到 filename

2>&1 则将标准错误重定向到标准输出，但此时标准输出指向 filename, 故标准错误输出也指向 filename

对于 `command 2>&1 > filename`

2>&1 将标准错误输出重定向到标准输出，但此时标准输出指向终端，故标准错误输出也指向终端

\> filename, 将标准输出重定向到 filename, 但并没有更改标准错误输出的行为，故标准错误输出还是指向终端

## 参考

[Linux Shell 重定向（输入输出重定向）精讲](http://c.biancheng.net/view/942.html)

[Shell 输入 / 输出重定向](https://www.runoob.com/linux/linux-shell-io-redirections.html)
