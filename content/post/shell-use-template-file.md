---
title: "Shell 使用模板文件"
date: 2020-09-09T11:13:35+08:00
tags: ["shell"]
---

## 需求来源

有个模板文件, 其占位符格式为: `${variable}`

现需要使用 shell 脚本来动态生成对应文件

## 实现

假设模板文件内容如下:

```sh
#!/usr/bin/env bash

version="${version}"
path="${path}"
```

则动态生成对应文件的 shell 脚本可以如下:

```sh
#!/usr/bin/env bash

version="1.0.0"
path="oh my god"

sed \
    -e "s/\${version}/${version}/g" \
    -e "s/\${path}/${path}/g" \
    path_to_template_file \
    > path_to_output_file
```

## 需要注意的坑

一般我们使用 `/` 作为 sed 的定界符, 但若变量值中包含 `/`, 则会导致 sed 解析失败

因此我们需要对 `/` 进行转义

```sh
#!/usr/bin/env bash

function handlingSlash() {
   echo "$1" | sed -e "s/\//\\\\\//g"
}

version="1.0.0"
path=$(handlingSlash "${HOME}/Desktop/avatar.jpeg")

sed \
    -e "s/\${version}/${version}/g" \
    -e "s/\${path}/${path}/g" \
    path_to_template_file \
    > path_to_output_file
```
