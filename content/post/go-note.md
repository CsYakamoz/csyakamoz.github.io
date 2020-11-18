---
title: "Go 笔记"
date: 2020-10-20T23:23:33+08:00
tags: ["go"]
draft: true
---

[Go 语言之旅](https://github.com/Go-zh/tour) 的笔记。

## 变量

格式：`var 变量名 类型`

---

当连续两个或多个函数的已命名形参类型相同时，除最后一个类型以外，其它都可以省略。

`x int, y int` -> `x, y int`

---

变量声明可以包含初始值，每个变量对应一个。

如果初始化值已存在，则可以省略类型；变量会从初始值中获得类型。

`var c, python, java = true, false, "no!"`

---

在函数中，简洁赋值语句 := 可在类型明确的地方代替 var 声明。

函数外的每个语句都必须以关键字开始（var, func 等等），因此 := 结构不能在函数外使用。

```golang
func main() {
	var i, j int = 1, 2
	k := 3
	c, python, java := true, false, "no!"
}
```

---

没有明确初始值的变量声明会被赋予它们的零值。

零值是：数值类型为 0，布尔类型为 false，字符串为 ""（空字符串），结构体则是遍历其字段，若是基本类型，则值为对应类型的零值，否则再次遍历其字段。

## 变量的基本类型

```
bool

string

int  int8  int16  int32  int64
uint uint8 uint16 uint32 uint64 uintptr

byte // uint8 的别名

rune // int32 的别名
    // 表示一个 Unicode 码点

float32 float64

complex64 complex128
```

int, uint 和 uintptr 在 32 位系统上通常为 32 位宽，在 64 位系统上则为 64 位宽。 当你需要一个整数值时应使用 int 类型，除非你有特殊的理由使用固定大小或无符号的整数类型。

## 指针

类型 \*T 是指向 T 类型值的指针。其零值为 nil。

`var p *int`

与 C 不同，Go 没有指针运算。

## 结构体

结构体字段使用点号来访问。

---

结构体字段可以通过结构体指针来访问。

如果我们有一个指向结构体的指针 p，那么可以通过 (\*p).X 来访问其字段 X。不过这么写太啰嗦了，所以语言也允许我们使用隐式间接引用，直接写 p.X 就可以。

---

特殊的前缀 \& 返回一个指向结构体的指针。

## 数组

格式：`var arr [n]T`, 拥有 n 个 T 类型的值的数组

---

类型 `[]T` 表示一个元素类型为 T 的切片。

切片通过两个下标来界定，即一个上界和一个下界，二者以冒号分隔：

`a[low : high]`

它会选择一个半开区间，包括第一个元素，但排除最后一个元素。

切片并不存储任何数据，它只是描述了底层数组中的一段。

更改切片的元素会修改其底层数组中对应的元素。

与它共享底层数组的切片都会观测到这些修改。