---
title: "Javascript 函数传参类型"
date: 2020-09-09T10:54:59+08:00
tags: ["javascript"]
---

曾经我一度将 javascript 函数传参类型分为两种:

1. 基本类型: 值传递
2. 引用类型: 引用传递

后来我发现, 其实都是**值传递**;

先说明为啥曾经认为引用类型, 是引用传递:

```javascript
function demo(obj) {
  obj.foo = "foo";
}

let variable = {};

console.log(variable); // {}

demo(variable);

console.log(variable); // { foo: 'foo' }
```

外部向函数 `demo` 传递实参 (`variable`);

函数进行操作: 向形参 (`obj`) 添加一个属性 (`foo`), 其值为 `foo`;

um..., 函数内部的操作, 会影响外部的变量, 这是很像引用传递, 但我们再看个例子:

```javascript
function demo(obj) {
  obj = { foo: "foo" };
  obj.bar = "bar";
}

let variable = {};

console.log(variable); // {}

demo(variable);

console.log(variable); // {}
```

为什么第二个输出依旧是 `{}` ???

---

后面查了资料, 得到与 C/C++ 相同(或许只是类似?)的概念

1. 基本类型, 其值存储在栈 (stack) 中
2. 引用类型, 其值存储在堆 (heap) 中
3. 堆中的数据需要由指针指向后, 才能访问

对于第一个 `demo`:

1. `demo(variable)`, 这里向 demo 传递的其实是指向 `variable` 的指针;
2. `obj.foo = "foo";`, 因为 obj 指向外部的 `variable`, 故该表达式会影响外部的 `variable`;

对于第二个 `demo`:

1. `demo(variable)`, 同上, 向 demo 传递的是指向 `variable` 的指针;
2. `obj = { foo: "foo" };`, 本来 obj 指向外部的 `variable`;

   但该表达式, 会创建新的对象 (`obj = { foo: "foo" };`), 并将该对象的内存地址赋值给 obj;

   故执行完该表达式后, obj 不再指向外部的 `variable`

3. `obj.bar = "bar";`, 因为 obj 不指向外部的 `variable`, 故该表达式也不会影响外部的 `variable`;

总结:

在 javascript 中, 函数传参类型只有一种 - **值传递**, 但分两种情况:

1. 基本类型: 直接传递原始值
2. 引用类型: 传递该对象在堆中的内存地址, 即指针
