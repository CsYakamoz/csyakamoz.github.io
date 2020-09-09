---
title: "JavaScript 遍历对象属性顺序"
date: 2020-09-09T10:37:51+08:00
tags: ["javascript"]
---

## 问题来源

```javascript
/**
 * @param {object} obj
 * @returns {any[]}
 */
function getValues(obj) {
    // some code or none
    return Object.values(obj);
}

const [val0, val1, ..., valN] = getValues(obj);
doSomethingFor0(val0);
doSomethingFor1(val1);
...
doSomethingForN(valN);
```

`getValues` 函数参数是对象,返回值是数组

调用者传入对象, 再对函数返回的数组, 进行如下操作:

- 对下标为 0 的元素做某事 0
- 对下标为 1 的元素做某事 1
- ...
- 对下标为 N 的元素做某事 N

在这里, 调用者认为, 该数组元素排序顺序会如预期所想(声明顺序, 插入顺序等等)

实际上, 该数组元素排序顺序依赖于**遍历对象属性顺序**, 但遍历对象属性顺序有时并非等价于对象的声明(插入)顺序, 故导致可能出现非预期结果

## 顺序规则

在 Google 查找相关资料后及个人测试, 得到如下结果:

先以三个区间划分, 然后区间内再各自排序

1. 非负整数(不包括 `n.0` 这种)区间, 按照从小到大排序
2. 普通的属性名区间, 按照声明(插入)顺序排序
3. Symbol 区间, 按照声明(插入)顺序排序

```javascript
/**
 * Object.values()
 * Object.entries()
 * for...in
 * JSON.stringify()
 * Object.keys() 得到的顺序与上面的相同
 **/

// Object.keys() is [1, foo, bar]
const obj = { foo: "foo", "1": "1", bar: "bar" };

/**
 * Object.keys() is
 * [
 * '0', '1', '2',
 * '10', 'm', 'b',
 * '-1', 'a', '0.0'
 * ]
 *
 * 注意: symbol 无法通过 keys() 得到, 因为其是不可枚举
 * 需要通过遍历 “Object.getOwnPropertySymbols()” 返回的数组来引用
 * 但直接通过 console.log 打印该对象, 可看到 symbol 排在最后
 **/
const someObj = {
  m: { value: function () {}, enumerable: true },
  2: { value: "2", enumerable: true },
  b: { value: "b", enumerable: true },
  0: { value: 0, enumerable: true },
  [Symbol()]: { value: "sym", enumerable: false },
  1: { value: "1", enumerable: true },
  "-1": { value: "-1", enumerable: true },
  a: { value: "a", enumerable: true },
  "10": { value: 10, enumerable: true },
  "0.0": { value: 0.0, enumerable: true },
};
```

## 解决方案

1.  不编写依赖遍历对象属性顺序的代码

2.  使用 `Map`, 根据 MDN 文档

    > Map 中的键值是有序的, 而添加到对象中的键则不是. 因此, 当对它进行遍历时, Map 对象是按插入的顺序返回键值

3.  在插入的时候, 额外增加一个字段以作排序根据

    插入的元素结构可以为: `{ createdAt: 时间戳 value: ... }`

    ```javascript
    const obj1 = {};
    obj1.a = "a";
    obj1["1"] = "1";
    obj1["0"] = "0";
    obj1["3"] = "3";
    console.log(Object.values(obj1)); // [ '0', '1', '3', 'a' ]

    const R = require("ramda");
    const getValues = R.pipe(
      R.toPairs,
      R.sort(R.ascend(R.path(["1", "createdAt"]))),
      R.map(R.pipe(R.last, R.prop("value")))
    );
    const obj2 = {};
    obj2.a = { createdAt: 1, value: "a" };
    obj2["1"] = { createdAt: 2, value: "1" };
    obj2["0"] = { createdAt: 3, value: "0" };
    obj2["3"] = { createdAt: 4, value: "3" };
    console.log(getValues(obj2)); // [ 'a', '1', '0', '3' ]
    ```

## 参考

- [Does JavaScript Guarantee Object Property Order?](https://stackoverflow.com/questions/5525795/does-javascript-guarantee-object-property-order)
- [MDN Map](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Map)
- [MDN Symbol](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Symbol)
