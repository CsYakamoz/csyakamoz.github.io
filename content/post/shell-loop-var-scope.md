---
title: "Shell 中 while 循环变量引发的问题"
date: 2021-03-18T00:11:44+08:00
tags: ["shell"]
draft: true
---

> bash-version: GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin18)

---

## 样例

**样例 1:**

```sh
#!/usr/bin/env bash
i=0
echo -e "foo\nbar\nzed"  | while read line; do
    i=$((i + 1))
    echo "in loop, i is ${i}"
done

echo "out loop, i is ${i}"

# output:
# in loop, i is 1
# in loop, i is 2
# in loop, i is 3
# out loop, i is 0
```

**样例 2:**

```sh
#!/usr/bin/env bash
i=0
for line in $(echo -e "foo\nbar\nzed") ; do
    i=$((i + 1))
    echo "in loop, i is ${i}"
done

echo "out loop, i is ${i}"

# output:
# in loop, i is 1
# in loop, i is 2
# in loop, i is 3
# out loop, i is 3
```

## 问题

为何样例 1 中, 最后打印的 i 的值为 `0`, 而样例 2 却是 `3` ?

## 原因

当个人写出类似于**样例 1**的代码时, `shellcheck` 提示 [SC2031: var was modified in a subshell. That change might be lost.][sc2031];

根据提示和该[文章][bashfaq/024], 以及搜索相关资料后, 得出如下结论:

样例 1 中的 `while` 循环是在子 shell 中执行的, 而子 shell 引进了新的上下文;

这个上下文中, 有着从父 shell 中**拷贝**而来的变量 - `i`, 其初始值为 `0`, 然后该变量用在 `while` 循环中;

当 `while` 循环结束时, 该上下文被销毁;

故父 shell 中的 `i` 并没有发生变化, 其值依旧是 `0`;

## 解决方案

`shellcheck` 给出的解决方案如下:

```sh
#!/usr/bin/env bash
i=0
while read line; do
    i=$((i + 1))
    echo "in loop, i is ${i}"
done < <(echo -e "foo\nbar\nzed")

echo "out loop, i is ${i}"

# output:
# in loop, i is 1
# in loop, i is 2
# in loop, i is 3
# out loop, i is 3
```

## 扩展

虽然问题解决了, 但是个人还是好奇两点:

1. 为什么样例 1 中的 while 是在子 shell 中执行?
2. 解决方案中的 `<(your command)` 是什么意思?
   根据 [Wikipedia - Process substitution](https://en.wikipedia.org/wiki/Process_substitution) 可知, `<(your command)` 相当于

TODO

[sc2031]: https://github.com/koalaman/shellcheck/wiki/SC2031
[bashfaq/024]: http://mywiki.wooledge.org/BashFAQ/024
[a variable modified inside a while loop is not remembered]: https://stackoverflow.com/questions/16854280/a-variable-modified-inside-a-while-loop-is-not-remembered
[bash: variable loses value at end of while read loop]: https://serverfault.com/questions/259339/bash-variable-loses-value-at-end-of-while-read-loop
