---
title: "Generic"
date: 2025-02-07T17:28:52+08:00
tags: ["golang", "generic"]
draft: true
---

```go
package main

import "fmt"

// Define the interface
type MyInterface interface {
	MyMethod() string
}

// Define the Foo type
type Foo struct {
	Name string
}

func (f Foo) MyMethod() string {
	return "Foo's MyMethod: " + f.Name
}

// Define the Bar type
type Bar struct {
	Value int
}

func (b Bar) MyMethod() string {
	return fmt.Sprintf("Bar's MyMethod: Value = %d", b.Value)
}

// MyGenericFunction is a generic function that accepts either Foo or Bar
func MyGenericFunction[T MyInterface](arg T) string {
	// You can directly call arg.MyMethod() because the type constraint guarantees it exists.
	return arg.MyMethod()
}

func main() {
	foo := Foo{Name: "Alice"}
	bar := Bar{Value: 42}

	fooResult := MyGenericFunction[Foo](foo)
	barResult := MyGenericFunction[Bar](bar)

	fmt.Println(fooResult)
	fmt.Println(barResult)
}

```
