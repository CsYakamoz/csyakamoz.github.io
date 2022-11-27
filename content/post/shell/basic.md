---
title: "Shell 基础"
date: 2020-09-09T11:35:19+08:00
tags: ["shell"]
---

## Manual

[Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)

## Lint

> [ShellCheck](https://github.com/koalaman/shellcheck), a static analysis tool for shell scripts

建议使用 `ShellCheck`, 以检查脚本中潜在的问题

## Shebang

**[shebang](https://zh.wikipedia.org/wiki/Shebang)** 即 `#!` , 其后面跟的是解释当前脚本的解释器路径

e.g.

1. `#!/bin/bash`
2. `#!/usr/bin/bash`
3. `#!/usr/bin/env bash`

个人习惯用 `#!/usr/bin/env NAME` 而不是 `#!/usr/bin/NAME`

原因请看此：[Why is it better to use “#!/usr/bin/env NAME” instead of “#!/path/to/NAME” as my shebang?](https://unix.stackexchange.com/questions/29608/why-is-it-better-to-use-usr-bin-env-name-instead-of-path-to-name-as-my)

## 变量

### 定义

`variable=value`

1. 不需要指定变量类型，即不需要说明是整型类型，还是字符串类型等等
2. 等号两侧**不能有空格**

### 使用

1. `$variable`
2. `${variable}`

`{}` 是可选的，但建议加上，`{}` 是为了帮助解释器识别变量的边界

```sh
for skill in Ada Coffee Action Java; do
    echo "I am good at ${skill}Script"
done
```

如果不给 `skill` 加上花括号，解释器会把 `skillScript` 当作变量，在上面的情况下，其值为空

### 只读变量，删除变量

```sh
# 将变量变为只读
readonly variable

# 删除变量，但不能删除只读变量
unset variable
```

### 三种变量类型

#### 全局变量

在 Shell 中定义的变量，默认都是全局变量

```sh
function func() {
    var=6
}

func

echo "${var}"
```

#### 局部变量

当想要变量的作用域仅限于函数内部时，在定义时加上 `local` 即可

```sh
function func() {
    local var=6
}

func

echo "${var}"
```

#### 环境变量

全局变量只在当前 Shell 进程中有效，对其它 Shell 进程和子进程都无效

如果使用 `export` 命令将全局变量导出，那么它就在所有的子进程中也有效了，这称为**环境变量**

环境变量被创建时所处的 Shell 进程称为父进程，如果在父进程中再创建一个新的进程来执行 Shell 命令，那么这个新的进程被称作 Shell 子进程

当 Shell 子进程产生时，它会继承父进程的环境变量为自己所用，所以说环境变量可从父进程传给子进程

不难理解，环境变量还可以传递给孙进程

注意：两个没有父子关系的 Shell 进程是不能传递环境变量的，并且环境变量只能向下传递而不能向上传递，即**传子不传父**

## 字符串

字符串可使用单引号 `'` 或者双引号 `"`

区别：

- 单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的
- 双引号里可以有变量，以及转义字符

### 使用

获取字符串长度：`${#string}`

提取子字符串：`${string:start:length}`

## 数组

Shell 支持一维数组，并且没有限制数组大小

类似于大多数编程语言，数组下标从 0 开始

### 定义

在 Shell 中，用括号来表示数组，数组元素用空格符号分割开

```sh
array=(value_1 value_2 ... value_n)

# or

array=(
    value_1
    value_2
    ...
    value_n
)
```

### 使用

获取指定下标元素：`${array[index]}`

更新指定下标元素：`array[index]=value`

获取数组长度：`${#array[*]}` 或者 `${#array[@]}`

获取数组的子数组, 语法类似于 string: `${array[@]:start:length}`

将字符串按空格隔开, 转成数组: `arr=($string)`

添加元素: `array+=("element")` or `array=(${array[@]} "element")`

拼接数组: `array=(${array0[@]} ${array1[@]})`

## if & while 语句

```sh
if [[ condition ]]; then
    statement
fi

while [[ condition ]]; do
    statement
done
```

| **数字**运算符 |   说明   |
| :------------: | :------: |
|      -eq       |   等于   |
|      -ne       |  不等于  |
|      -gt       |   大于   |
|      -lt       |   小于   |
|      -ge       | 大于等于 |
|      -le       | 小于等于 |

| 关系运算符 | 说明 |
| :--------: | :--: |
|     !      |  非  |
|     &&     |  与  |
|    \|\|    |  或  |

| **字符串**运算符 |    说明    |
| :--------------: | :--------: |
|        ==        |    等于    |
|        !=        |   不等于   |
|        -z        | 是否为空串 |
|        -n        | 是否非空串 |
|    `<` or `>`    | 字典序比较 |

| 文件测试运算符 |                    说明                    |
| :------------: | :----------------------------------------: |
|       -d       |                  是否目录                  |
|       -f       | 是否普通文件（既不是目录，也不是设备文件） |
|    -e or -a    |                  是否存在                  |
|    -L or -h    |          是否存在并且是个符号链接          |

| 变量运算符 |                                  说明                                  |
| :--------: | :--------------------------------------------------------------------: |
| -v varname | True if the shell variable varname is set (has been assigned a value). |
| -R varname |   True if the shell variable varname is set and is a name reference.   |

> Tips: [name-reference](https://unix.stackexchange.com/questions/510715/what-is-a-name-reference-variable-attribute)

## 算术运算符

格式：`$((表达式))`

```sh
a=20
b=5

echo $((a + b)) # 25
echo $((a - b)) # 15
echo $((a * b)) # 100
echo $((a / b)) # 4
```

不优先使用 `expr` 的原因：

1. 运算符号两边要有空格
2. 引用变量时需要使用 `$`
3. `*` 需要额外加个 `\`
4. [expr is antiquated. Consider rewriting this using `$((..))`, `${}` or `[[ ]]`](https://github.com/koalaman/shellcheck/wiki/SC2003)

## for 语句

```sh
for (( i = 0; i < count; i++ )); do
    statement
done

for i in words; do
    statement
done
```

## 管道

两个命令之间使用 |（竖线）运算符，将第一个命令的 stdout 定向到第二个命令的 stdin

```sh
command1 | command2 paramater1 | command3 parameter1 - parameter2 | command4
```

## 参考

[Shell 教程](https://www.runoob.com/linux/linux-shell.html)

[Shell 变量的作用域：Shell 全局变量、环境变量和局部变量](http://c.biancheng.net/view/773.html)

[linux 重定向（shell 重定向，输入重定向，输出重定向）](https://blog.csdn.net/win_turn/article/details/50379465)
