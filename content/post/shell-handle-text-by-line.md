---
title: "Shell 按行处理文本"
date: 2020-09-09T11:15:00+08:00
tags: ["shell"]
---

内容来源: [【Shell 脚本】逐行处理文本文件](https://www.cnblogs.com/dwdxdy/archive/2012/07/25/2608816.html)

## read

```sh
cat data.dat | while read line
do
    echo "${line}"
done

# or

while read line
do
    echo "${line}"
done < data.dat
```

## awk

```sh
cat data.dat | awk '{print $0}'
```

## for ... in ...

`for var in content` 表示变量 `var` 在 `content` 中循环取值, 取值的分隔符由 `${IFS}` 确定

```sh
for line in $(cat data.dat)
do
    echo "${line}"
done
```

如果输入文本每行中没有空格, 则 `line` 在输入文本中按换行符分隔符循环取值.

如果输入文本中包括空格或制表符, 则不是换行读取, `line` 在输入文本中按空格分隔符或制表符或换行符循环取值.

可以通过把 `${IFS}` 设置为换行符来达到逐行读取的功能.

**`${IFS}` 的默认值为：空白 (包括：空格，制表符，换行符)**.
