---
title: "编码风格"
date: 2020-09-09T10:32:18+08:00
tags: ["javascript", "coding-style"]
---

## ESLint

> [ESLint](https://eslint.org/) is a tool for identifying and reporting on patterns found in ECMAScript/JavaScript code, with the goal of making code more consistent and avoiding bugs.

以下风格都会尽量补充对应的 eslint 规则（如果有且被我发现的话 😑

**Notice**: 请优先以团队约定为准!!!

## 缩进使用空格而不是制表符

尽管制表符更省空间，但还是更喜欢空格

> one tab is equal to 2, 4, 8 space

## 坚持使用分号

纵然很多人依旧坚持不使用分号，但我就喜欢加分号，就这么滴。

- `semi`

## 坚持使用大括号

即使只有一条语句，也依旧要使用大括号；

同时，`else` 与 `if` 的 `}` 处在统一行；

<!-- prettier-ignore -->
```javascript
// bad
if (test) return false;
else return true;

// bad
if (test)
    return false;
else
    return true;

// bad
if (test) {
    return false;
}
else {
    return true;
}

// good
if (test) {
    return false;
} else {
    return true;
}
```

- `curly`
- `brace-style`
- `nonblock-statement-body-position`

## const 优于 let, 弃用 var

`var` 的坏处，此处不一一阐述；

`let` 声明的变量，其生存周期只在其声明时所在的代码块有效，且不存在 "变量提升" 现象，当然还有其它好处，此处也不一一阐述；

`const` 与 `let` 最大区别是：`const` 声明时必须就为其赋值，且该值不能改变；

使用 `const` 能减少程序的不确定性，因为我们能确保其值不会改变，因此如果一个变量在声明时被赋值，且后续逻辑中并没有改变其值，我们应当将其变成常量。

目前个人遇到的绝大部分情况，都可以用 `const` 代替 `let`，下面是一个场景：

```javascript
// bad
let discount;

if (isLoggedIn) {
  if (cartTotal > 100 && !isFriday) {
    discount = 30;
  } else if (!isValuedCustomer) {
    discount = 20;
  } else {
    discount = 10;
  }
} else {
  discount = 0;
}

// good
const getDiscount = ({ isLoggedIn, cartTotal, isValuedCustomer }) => {
  if (!isLoggedIn) {
    return 0;
  }

  if (cartTotal > 100 && !isFriday) {
    return 30;
  }

  if (!isValuedCustomer) {
    return 20;
  }

  return 10;
};

const discount = getDiscount({ isLoggedIn, isValuedCustomer, cartTotal });
```

- `no-undef`
- `prefer-const`
- `no-const-assign`
- `no-var`

## 多个变量声明或赋值，则每个变量分开声明或赋值

`let` 声明放在一组，`const` 则放在另外一组

<!-- prettier-ignore -->
```javascript
// bad
const items = getItems(),
  goSportsTeam = true,
  dragonball = "z";

// bad
// (compare to above, and try to spot the mistake)
const items = getItems(),
  goSportsTeam = true;
  dragonball = "z";

// good
const items = getItems();
const goSportsTeam = true;
const dragonball = "z";

/* --- */
// bad
let i,
  len,
  dragonball,
  items = getItems(),
  goSportsTeam = true;

// bad
let i;
const items = getItems();
let dragonball;
const goSportsTeam = true;
let len;

// good
const goSportsTeam = true;
const items = getItems();
let dragonball;
let i;
let length;
```

- `one-var`

## 在需要时，才声明变量

而不是一开始就声明可能用到的变量

```javascript
// bad - unnecessary function call
function checkName(hasName) {
  const name = getName();

  if (hasName === "test") {
    return false;
  }

  if (name === "test") {
    this.setName("");
    return false;
  }

  return name;
}

// good
function checkName(hasName) {
  if (hasName === "test") {
    return false;
  }

  const name = getName();

  if (name === "test") {
    this.setName("");
    return false;
  }

  return name;
}
```

## 不允许未使用的变量

> Why? Variables that are declared and not used anywhere in the code are most likely an error due to incomplete refactoring. Such variables take up space in the code and can lead to confusion by readers.

```javascript
// bad

var some_unused_var = 42;

// Write-only variables are not considered as used.
var y = 10;
y = 5;

// A read for a modification of itself is not considered as used.
var z = 0;
z = z + 1;

// Unused function arguments.
function getX(x, y) {
  return x;
}

// good

function getXPlusY(x, y) {
  return x + y;
}

var x = 1;
var y = a + 2;

alert(getXPlusY(x, y));

// 'type' is ignored even if unused because it has a rest property sibling.
// This is a form of extracting an object that omits the specified keys.
var { type, ...coords } = data;
// 'coords' is now the 'data' object without its 'type' property.
```

## 变量，常量，函数和类的命名约定

当命名变量和方法的时候，使用 **lowerCamelCase**;

当命名类的时候，使用 **UpperCamelCase** （首字母大写）;

对于常量，则 **UPPERCASE with Underscore**;

这将帮助您轻松地区分普通变量 / 函数和需要实例化的类；使用描述性名称，但使它们尽量简短。

- `camelcase`
- `new-cap`

## if...elif...else 的注释

因为 `else` 与 `if` 的 `}` 处在同一行，其注释写法可以如下

```javascript
/**
 * condition1: your comment
 * condition2: your comment
 * other: your comment
 */
if (condition1) {
  // doSomething
} else if (condition2) {
  // doSomething
} else {
  // doSomething
}
```

## 对象属性或方法名仅在需要时才加上引号

<!-- prettier-ignore -->
```javascript
// bad
const bad = {
  'foo': 3,
  'bar': 4,
  'data-blah': 5,
};

// good
const good = {
  foo: 3,
  bar: 4,
  'data-blah': 5,
};
```

- `quote-props`

## 优先使用对象字面量简写语法

简写语法：

1. 方法不需要加 `function`
2. 同名属性 / 方法不需要 `key: key,`，写成 `key,` 即可

简写语法应当放在对象声明的开头

```javascript
const lukeSkywalker = "Luke Skywalker";
const moonWithoutStar = "moon without star";
const method = () => "always";

// bad
const atom = {
  lukeSkywalker: lukeSkywalker,

  value: 1,
  moonWithoutStar: moonWithoutStar,

  addValue: function (value) {
    return atom.value + value;
  },

  method: method,
};

// good
const atom = {
  lukeSkywalker,
  moonWithoutStar,
  method,

  value: 1,

  addValue(value) {
    return atom.value + value;
  },
};
```

- `object-shorthand`

## 优先通过扩展运算符来浅拷贝对象，数组

```javascript
/* 对象 */
// very bad
const original = { a: 1, b: 2 };
const copy = Object.assign(original, { c: 3 }); // this mutates `original` ಠ_ಠ
delete copy.a; // so does this

// bad
const original = { a: 1, b: 2 };
const copy = Object.assign({}, original, { c: 3 }); // copy => { a: 1, b: 2, c: 3 }

// good
const original = { a: 1, b: 2 };
const copy = { ...original, c: 3 }; // copy => { a: 1, b: 2, c: 3 }

const { a, ...noA } = copy; // noA => { b: 2, c: 3 }

/* 数组 */
// bad
const len = items.length;
const itemsCopy = [];
let i;

for (i = 0; i < len; i += 1) {
  itemsCopy[i] = items[i];
}

// good
const itemsCopy = [...items];
```

- `prefer-object-spread`

## 尽可能使用解构赋值

```javascript
// bad
function getFullName(user) {
  const firstName = user.firstName;
  const lastName = user.lastName;

  return `${firstName} ${lastName}`;
}

// good
function getFullName(user) {
  const { firstName, lastName } = user;
  return `${firstName} ${lastName}`;
}

// best
function getFullName({ firstName, lastName }) {
  return `${firstName} ${lastName}`;
}

/* --- */

const arr = [1, 2, 3, 4];

// bad
const first = arr[0];
const second = arr[1];

// good
const [first, second] = arr;
```

- `prefer-destructuring`

## 字符串避免无用的转义

```javascript
// bad
const foo = "'this' is \"quoted\"";

// good
const foo = "'this' is \"quoted\"";
const foo = `my name is '${name}'`;
```

## 如果函数返回值有多个，且意义不一样，优先考虑对象

> Why? You can add new properties over time or change the order of things without breaking call sites.

```javascript
// bad
function processInput(input) {
  // then a miracle occurs
  return [left, right, top, bottom];
}

// the caller needs to think about the order of return data
const [left, __, top] = processInput(input);

// good
function processInput(input) {
  // then a miracle occurs
  return { left, right, top, bottom };
}

// the caller selects only the data they need
const { left, top } = processInput(input);
```

## 函数的默认参数总是放在后面

```javascript
// bad
function handleThings(opts = {}, name) {
  // ...
}

// good
function handleThings(name, opts = {}) {
  // ...
}
```

## 尽量使用扩展语法调用可变参数函数

```javascript
// bad
const x = [1, 2, 3, 4, 5];
console.log.apply(console, x);

// good
const x = [1, 2, 3, 4, 5];
console.log(...x);

// bad
new (Function.prototype.bind.apply(Date, [null, 2016, 8, 5]))();

// good
new Date(...[2016, 8, 5]);
```

## 回调函数总是使用箭头函数表达式

```javascript
// bad
[1, 2, 3].map(function (x) {
  const y = x + 1;
  return x * y;
});

// good
[1, 2, 3].map((x) => {
  const y = x + 1;
  return x * y;
});
```

- `prefer-arrow-callback`

## 限制函数参数个数

函数如果有许多参数的话，会难以阅读和书写，因为要记住每个参数是什么，它的类型以及它们出现顺序；

因此建议，约定一个函数中参数个数的上限。

如果函数参数个数无法缩减，可以将这些参数合并成一个对象，然后在函数实现中使用对象解构。

```javascript
// bad
function foo(bar, baz, qux, xyz) {
  doSomething();
}

// good
function foo({ bar, baz, qux, xyz }) {
  doSomething();
}
```

- `max-params`

## 禁止对函数参数再赋值

上文提到过 `const` 的好处，对于函数参数，道理是一样滴。

- `no-param-reassign`

## 函数表达式优于函数声明

理由请见：[https://github.com/airbnb/javascript#functions--declarations](https://github.com/airbnb/javascript#functions--declarations)

```javascript
// bad
function foo() {
  // ...
}

// bad
const foo = function () {
  // ...
};

// good
// lexical name distinguished from the variable-referenced invocation(s)
const short = function longUniqueMoreDescriptiveLexicalFoo() {
  // ...
};
```

- `func-style`

## 建议使用剩余参数代替 arguments

`arguments` 没有 `Array.prototype` 方法，所以有点不方便。

- `prefer-rest-params`

```javascript
// bad
function concatenateAll() {
  const args = Array.prototype.slice.call(arguments);
  return args.join("");
}

// good
function concatenateAll(...args) {
  return args.join("");
}
```

## 避免使用不带 await 表达式的 async 函数

JavaScript 中的异步函数与其他函数在两个重要方面表现不同：

1. 返回值总是一个  `Promise`
2. 你可以在其中使用  `await`  操作符

不使用 `await` 的异步函数可能不需要是异步函数（但函数返回值却是`Promise`) , 也可能是重构的意外结果。

- `require-await`

## 避免不必要的 return await

在 `async function`, `return await` 很少有用；

因为 `async function` 的返回值总是封装在 `Promise.resolve`, `return await` 实际上并没有做任何事情，只是在 Promise resolve 或 reject 之前增加了额外的时间；

唯一有效是，如果 try/catch 语句中使用 `return await` 来捕获另一个基于 Promise 的函数的错误，则会出现异常。

- `no-return-await`

## 函数表达式或箭头函数如果只有一个参数，也加上括号

> Why? Minimizes diff churn when adding or removing arguments.

<!-- prettier-ignore -->
```javascript
// bad
[1, 2, 3].map(x => x * x);

// good
[1, 2, 3].map((x) => x * x);

// bad
[1, 2, 3].map(number => (
  `A long string with the ${number}. It’s so long that we don’t want it to take up space on the .map line!`
));

// good
[1, 2, 3].map((number) => (
  `A long string with the ${number}. It’s so long that we don’t want it to take up space on the .map line!`
));

// bad
[1, 2, 3].map(x => {
  const y = x + 1;
  return x * y;
});

// good
[1, 2, 3].map((x) => {
  const y = x + 1;
  return x * y;
});
```

- `arrow-parens`

## 不使用魔术数字 (Magic Number)

[魔术数字](<https://en.wikipedia.org/wiki/Magic_number_(programming)>) 可以是指硬编码在代码里的具体数值（如 “10”“123” 等以数字直接写出的值）;

虽然程序作者写的时候自己能了解数值的意义，但对其他程序员而言，甚至制作者本人经过一段时间后，会难以了解这个数值的用途，只能苦笑讽刺 "这个数值的意义虽然不懂，不过至少程序能够运行，真是个魔术般的数字" 而得名。

> 本人已在团队中遇到过这种情况（自己写的和他人写的都有！!!), 所以这个规则是很重要滴！

- `no-magic-numbers`

## 使用严格比较运算符

严格比较运算符不会尝试转换它们为恰当的类型来比较。

- `eqeqeq`

## 条件语句中的条件需写清楚比较对象，除了布尔值

- **Objects** evaluate to **true**
- **Undefined** evaluates to **false**
- **Null** evaluates to **false**
- **Booleans** evaluate to **the value of the boolean**
- **Numbers** evaluate to **false** if **+0, -0, or NaN**, otherwise **true**
- **Strings** evaluate to **false** if an empty string `''`, otherwise **true**

```javascript
// bad
if (isValid === true) {
  // ...
}

// good
if (isValid) {
  // ...
}

// bad
if (name) {
  // ...
}

// good
if (name !== "") {
  // ...
}

// bad
if (collection.length) {
  // ...
}

// good
if (collection.length > 0) {
  // ...
}
```

## 避免在 switch 的 case 中出现词法声明

词法声明 (let, const, function, class) 在整个 switch 语句块中是可见的，但是它只有在运行到它定义的 case 语句时，才会进行初始化操作

为了保证词法声明语句只在当前 case 语句中有效，将你子句包裹在块中

```javascript
// bad
switch (foo) {
  case 1:
    let x = 1;
    break;
  case 2:
    const y = 2;
    break;
  case 3:
    function f() {
      // ...
    }
    break;
  default:
    class C {}
}

// good
switch (foo) {
  case 1: {
    let x = 1;
    break;
  }
  case 2: {
    const y = 2;
    break;
  }
  case 3: {
    function f() {
      // ...
    }
    break;
  }
  case 4:
    bar();
    break;
  default: {
    class C {}
  }
}
```

## 避免长文件

根据个人经验，一个特别长的代码文件，很难理解，和维护；

因此建议将大文件拆分成更细粒度的模块。

- `max-lines`

## 避免长函数

程序复杂度的一个来源是漫长而复杂的函数，很难推理；

而且函数职责太多，很难测试。

- `max-lines-per-function`

## 避免复杂函数

复杂函数往往就是长函数，反之亦然；

函数之所以变复杂可能有很多因素，但其中嵌套回调和圈复杂度较高都是比较容易解决的。

> 圈复杂度：它指的是给定函数中的语句（逻辑）数，诸如 if 语句，循环和 switch 语句

- `complexity`
- `max-nested-callbacks`
- `max-depth`

## 禁止抛出异常字面量

当抛错时，仅抛出 `Error` 类，或者以 `Error` 为父类的继承类的错误；

使用 `Error` 类对象最基本的好处是它们能自动地追踪到异常产生和起源的地方。

同时，传递给 `Promise` 的 `reject` 也应该是 `Error` 类对象

- `no-throw-literal`
- `prefer-promise-reject-errors`

## 避免不必要的 catch 子句

只重新抛出原始错误的 catch 子句是冗余的，对程序的运行时行为没有影响；

这些冗余子句可能会导致混乱和代码膨胀，所以最好不要使用这些不必要的 catch 子句。

- `no-useless-catch`

## 建议在正则表达式中使用命名捕获组

随着 ECMAScript 2018 的发布，命名捕获组可以用于正则表达式中，这可以提高正则表达式的可读性。

格式：`/(?<name>pattern)/`

```javascript
// bad
const foo = /(ba[rz])/;
const bar = new RegExp("(ba[rz])");
const baz = RegExp("(ba[rz])");

foo.exec("bar")[1]; // Retrieve the group result.

// good
const foo = /(?<id>ba[rz])/;
const bar = new RegExp("(?<id>ba[rz])");
const baz = RegExp("(?<id>ba[rz])");

foo.exec("bar").groups.id; // Retrieve the group result.
```

- `prefer-named-capture-group`

## 变量命名习惯

- 布尔相关命名加上 is, can, should, has 等前缀，或者 [a]ble 后缀
- 用 min, max 表示数量范围
- 用 first, last 表示闭区间
- 用 begin, end 表示左闭右开区间

## 参考

- [JS 代码脏乱差？你需要知道这些优化技巧](https://www.infoq.cn/article/UDsIAw36kwXwkXLNx_QT)
- [🛁 Clean Code concepts adapted for JavaScript](https://github.com/ryanmcdermott/clean-code-javascript)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- [Cs-Notes](https://github.com/CyC2018/CS-Notes)
