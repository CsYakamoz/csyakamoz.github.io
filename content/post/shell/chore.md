---
title: "Shell 零碎笔记"
date: 2021-01-22T00:19:44+08:00
tags: ["shell"]
---

## 命令补全

官方文档: `man bash`, 按 `/`, 输入 `Programmable Completion` 回车

[团子的小窝 - 编写 Bash 补全脚本](https://kodango.com/bash-competion-programming)

[如何编写 bash 自动补全脚本](https://www.infoq.cn/article/bash-programmable-completion-tutorial)

## 检查某命令是否存在

来源: [How can I check if a program exists from a Bash script?](https://stackoverflow.com/questions/592620/how-can-i-check-if-a-program-exists-from-a-bash-script)

```sh
command -v <the_command>
```

例子:

```sh
if ! command -v COMMAND &> /dev/null
then
    echo "COMMAND could not be found"
    exit
fi
```

> `&>` 的意思可见: [What are the shell's control and redirection operators?](https://unix.stackexchange.com/questions/159513/what-are-the-shells-control-and-redirection-operators) or [What's the accurate meaning of “exec &>/var/log/a.log” in a shell script?](https://serverfault.com/questions/739009/whats-the-accurate-meaning-of-exec-var-log-a-log-in-a-shell-script)

## 排序版本号

使用 `sort` 命令, 配合 `-V` 选项

> -V, --version-sort

```sh
# 从小到大排序
echo -e '1.2.100.4\n1.2.3.4\n10.1.2.3\n9.1.2.3' | sort -V

# output
# 1.2.3.4
# 1.2.100.4
# 9.1.2.3
# 10.1.2.3

# 从大到小排序
echo -e '1.2.100.4\n1.2.3.4\n10.1.2.3\n9.1.2.3' | sort -rV

# output
# 10.1.2.3
# 9.1.2.3
# 1.2.100.4
# 1.2.3.4
```

## 检查某命令(软件)的是满足最低版本

来源: [How to compare a program's version in a shell script?](https://unix.stackexchange.com/questions/285924/how-to-compare-a-programs-version-in-a-shell-script)

```sh
#!/bin/bash
currentver="$(gcc -dumpversion)"
requiredver="5.0.0"
if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then
       echo "Greater than or equal to ${requiredver}"
else
       echo "Less than ${requiredver}"
fi
```

## 快速复制 id_rsa.pub 到远程服务器

```sh
ssh-copy-id -i identity_file user@hostname
```

## 快速备份某文件

```sh
cp filename{,.bak}

# 等价于 cp filename filename.bak
```

这里使用了 [Bash 的模式扩展](https://wangdoc.com/bash/expansion.html#%E5%A4%A7%E6%8B%AC%E5%8F%B7%E6%89%A9%E5%B1%95)

## "并发"

来源: [Concurrency in Shell Scripts](https://stackoverflow.com/questions/24843570/concurrency-in-shell-scripts)

```
cmd0 &
cmd1 &
cmd2 &
wait
```

With no parameters it waits for all background processes to finish.

With a PID it waits for the specific process.
