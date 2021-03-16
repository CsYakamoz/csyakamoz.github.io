---
title: "JavaScript 中 isNaN 和 Number.isNaN 的区别"
date: 2021-03-16T14:37:33+08:00
tags: ["javascript"]
---

## isNaN vs Number.isNaN

`isNaN`: 判断参数是否为 NaN 本身, 或者无法转为数字.

`Number.isNaN`: 仅判断参数是否为 NaN 本身(完全匹配, 类似于 `===`).

例如:

```javascript
isNaN({});
// <- true, {} is not a number
// {} 无法转为数字

isNaN("ponyfoo");
// <- true, "ponyfoo" is not a number
// "ponyfoo" 无法转为数字

isNaN(NaN);
// <- true, NaN is not a number
// NaN 本身

isNaN("pony" / "foo");
// <- true, "pony"/"foo" is NaN, NaN is not a number
// "pony" 和 "foo" 皆无法转为数字, 故 '/' 操作符的结果是 NaN

isNaN("123");
// <- false, "123" 可转为数字

Number.isNaN({});
// <- false, {} is not NaN
// 类型不是 Number

Number.isNaN("ponyfoo");
// <- false, 'ponyfoo' is not NaN
// 类型不是 Number

Number.isNaN(NaN);
// <- true, NaN is NaN
// 类型是 Number, 且是 NaN

Number.isNaN("pony" / "foo");
// <- true, "pony"/"foo" is NaN, NaN is NaN
// 如上, 其结果是 NaN, 故返回 true

Number.isNaN("123");
// <- false, 类型不是 Number

Number.isNaN(123);
// <- false, 类型是 Number, 但并不是 NaN
```

## 扩展 - isFinite vs Number.isFinite

`isFinite` 和 `Number.isFinite` 是否有类似的逻辑呢?

`isFinite`: 判断参数是否为有穷数, 或者可转换为有穷数.

`Number.isFinite`: 仅判断参数是否为有穷数.

```javascript
isFinite(Infinity);
// <- false
isFinite(NaN);
// <- false
isFinite(-Infinity);
// <- false
isFinite(0);
// <- true
isFinite(2e64);
// <- true
isFinite(910);
// <- true
isFinite(null);
// <- true, would've been false with the more robust Number.isFinite(null)
isFinite("0");
// <- true, would've been false with the more robust Number.isFinite("0")

// ---

Number.isFinite(Infinity);
// <- false
Number.isFinite(NaN);
// <- false
Number.isFinite(-Infinity);
// <- false
Number.isFinite(0);
// <- true
Number.isFinite(2e64);
// <- true
Number.isFinite("0");
// <- false, would've been true with global isFinite('0')
Number.isFinite(null);
// <- false, would've been true with global isFinite(null)
```

## 参考

[Confusion between isNaN and Number.isNaN in javascript](https://stackoverflow.com/questions/33164725/confusion-between-isnan-and-number-isnan-in-javascript)
[MDN - Number.isNaN()](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Number/isNaN)
[MDN - isNaN()](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/isNaN)
[MDN - Number.isFinite()](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Number/isFinite)
[MDN - isFinite()](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/isFinite)
