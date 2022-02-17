---
title: "Node.js 创建本地模块"
date: 2020-09-09T11:00:07+08:00
tags: ["javascript"]
---

## 问题来源

在编写代码时，个人习惯会把通用实用模块放在项目根目录下

因为是通用实用模块，若项目层级较多，那么层级较深的文件引用该模块时，会出现这样的代码：

```javascript
const Utils = require("../../../../../../../utils");
```

这么多的 `..`, 如果写少或写多一个 `..`, 就会报错

Oh, it makes me uncomfortable 😑

因此，需求是可以用简单的路径引用通用实用模块

## Solution One

使用 [module-alias](https://www.npmjs.com/package/module-alias), 简洁且易用

个人认为只有一个缺点 - 它更改 `Module._resolveFilename` 方法

## Solution Two

`npm` 和 `yarn` 现已支持安装本地模块

首先需要为本地模块添加 `package.json` 文件

> 对于 package.json, 其 name, version 是必需的

本地模块的名字为 `package.json` 的 `name` 字段，而不是本地模块所处目录名

假设本地模块相对于项目根目录的路径是 `./local-package-dir`, 其在 package.json 文件中的 `name` 为 `local-package`

则安装本地模块的方法如下：

```sh

# 在 node_modules 中创建软链 local-package 指向 ../local-package-dir
npm install ./local-package-dir

# 拷贝 ./local-package-dir 的所有文件，放到 node_modules/local-package
yarn add ./local-package-dir

# 在 node_modules 中创建软链 local-package 指向 ../local-package-dir
yarn add link:./local-package-dir

```

现在引用本地模块时，可这么写：

```javascript
const package = require("local-package");
```

## 参考

[Wrap common utilities as npm packages](https://github.com/goldbergyoni/nodebestpractices/blob/master/sections/projectstructre/wraputilities.md)

[2018 年了，你还是只会 npm install 吗？](https://juejin.im/post/5ab3f77df265da2392364341)

[npm install](https://docs.npmjs.com/cli/install.html)

[yarn add](https://classic.yarnpkg.com/en/docs/cli/add/)
