---
title: "forEach With Async Function in Js"
date: 2020-09-09T14:05:20+08:00
tags: ["javascript"]
---

```javascript
const sleep = (ms) =>
  new Promise((resolve) => setTimeout(() => resolve(ms), ms * 1000));
```

假设我们需要对数组中的三个元素进行**异步**操作，而且要按顺序。

即，对数组中的元素按**顺序**调用异步函数（本文为 `sleep`)，我们也许会用 `Array.prototype.forEach` 写出下面的代码：

```javascript
(async () => {
  const begin = Date.now();
  const arr = [1, 2, 3];
  arr.forEach(async (num) => {
    console.log(await sleep(num));
  });

  console.log("finish");
  const end = Date.now();
  console.log(`time: ${end - begin}`);
})();
```

我们期待的结果为：

```text
1
2
3
finish
time: x    //  x >= 6000
```

但执行上述代码后，你将获得如下结果：

```text
finish
time: x    // x < 1000
1
2
3
```

我们先看看 `Array.forEach` 的类似原理：

```javascript
Array.prototype.forEach = function (callback) {
  // this point to our array
  for (let index = 0; index < this.length; index++) {
    // We call the callback for each entry
    callback(this[index], index, this); // no await!!!
  }
};
```

> ECMA-262 第 5 版中指定的算法：[Array.prototype.forEach()](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach#Polyfill)

如你所见，`callback` 函数是被调用，但并没有等待 ( `await` ) `callback` 函数结束。

正确的做法是不使用 `forEach()`，而是使用 `for` or `for of` 循环 or `reduce`（误）：

```javascript
(async () => {
  const begin = Date.now();
  const arr = [1, 2, 3];

  for (let i = 0; i < arr.length; i++) {
    console.log(await sleep(arr[i]));
  }
  // or
  for (const num of arr) {
    console.log(await sleep(num));
  }
  // or
  await arr.reduce(
    (acc, curr) =>
      acc.then(async () => {
        console.log(await sleep(curr));
      }),
    Promise.resolve()
  );

  console.log("finish");
  const end = Date.now();
  console.log(`time: ${end - begin}`);
})();
```

执行上述代码，可以得到预期的结果：

```text
1
2
3
finish
time: x    // x >= 6000
```

参考文章：

[javascript async await with foreach](https://codeburst.io/javascript-async-await-with-foreach-b6ba62bbf404?gi=704caa41d94)

[JavaScript loops — how to handle async/await](https://blog.lavrton.com/javascript-loops-how-to-handle-async-await-6252dd3c795)
