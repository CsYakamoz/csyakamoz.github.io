---
title: "Shell 常用快捷键"
date: 2020-09-09T11:06:40+08:00
tags: ["shell"]
---

Up, Ctrl + p, 向上移动光标或显示上一条命令

Down, Ctrl + n, 向下移动或显示下一条命令

Left, Ctrl + b, 光标向左移动一个字符

Right, Ctrl + f, 光标向右移动一个字符

BS, Ctrl + h, 删除光标左边的字符

Del, Ctrl + d, 删除光标右边的字符

Home, Ctrl + a, 跳转到行首

End, Ctrl + e, 跳转到行尾

> 以上快捷键可在 Mac 中的大多数文本编辑区域使用
>
> e.g.
>
> - Google Chrome 的地址栏
> - Wechat 的聊天内容输入框

Ctrl + w, 删除光标左边一个单词

Alt + b, 光标向左移动一个单词

Alt + f, 光标向右移动一个单词

Alt + d, 删除光标右边的一个单词

Alt + BS, 删除光标左边的一个单词

Ctrl + k, 删除光标到行尾的文本

Ctrl + u, 删除光标到行首的文本

---

Ctrl + c, 结束当前命令 / 进程

Ctrl + l, 清屏

Ctrl + z, 暂停前台进程返回 shell, 需要切换回前台进程时可使用 `fg`

Ctrl + r, 历史命令反向搜索，使用 `Ctrl + g` or `Ctrl + c` 退出搜索

---

Ctrl + x, Ctrl + e, 使用指定编辑器编辑当前命令，常用在编辑长命令

> 默认编辑器由环境变量 `EDITOR` 指定

## 参考

[Readline Shortcut](https://github.com/chzyer/readline/blob/master/doc/shortcut.md)
