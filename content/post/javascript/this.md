---
title: "Javascript this 的指向"
date: 2020-09-09T16:14:29+08:00
tags: ["javascript"]
---

```javascript
// Notice: the environment is Node.js

global.val = "global";
this.val = "exports";

function normalFun() {
  console.log(this.val);
}

const funcExpression = function () {
  console.log(this.val);
};

const arrowFun = () => {
  console.log(this.val);
};

const scope = {
  val: "obj",

  a: function () {
    console.log(this.val);
  },

  b: () => {
    console.log(this.val);
  },

  c: function () {
    return () => {
      console.log(this.val);
    };
  },

  d: function () {
    return function () {
      console.log(this.val);
    };
  },
};

const _c = scope.c;
const _d = scope.d;

normalFun(); // global
funcExpression(); // global
arrowFun(); // exports
scope.a(); // obj
scope.b(); // exports
scope.c()(); // obj
scope.d()(); // global
_c()(); // global
_d()(); // global
```

## 参考

[MDN this](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Operators/this)
