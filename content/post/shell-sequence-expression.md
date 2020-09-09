---
title: "Shell 序列表达式"
date: 2020-09-09T11:18:01+08:00
tags: ["shell"]
---

格式：`{FIRST..LAST[..INCREMENT]}`

`FIRST` 和 `LAST` 是必需的，用 `..` 分隔，中间没有空格，`INCREMENT` 是可选滴

## Example

```sh
echo {1..3} # 1 2 3

echo {3..1} # 3 2 1

echo {0..20..5} # 0 5 10 15 20

echo 0{8..10} # 08 09 010

echo {08..10} # 08 09 10

echo {a..f} # a b c d e f

echo {f..a} # f e d c b a

echo T-{a..f}-T # T-a-T T-b-T T-c-T T-d-T T-e-T T-f-T

echo {A..z} # A B C D E F G H I J K L M N O P Q R S T U V W X Y Z [ \ ] ^ _ ` a b c d e f g h i j k l m n o p q r s t u v w x y z

echo {z..A} # z y x w v u t s r q p o n m l k j i h g f e d c b a ` _ ^ ] \ [ Z Y X W V U T S R Q P O N M L K J I H G F E D C B A

```

```sh
for i in {0..3}; do
    echo "Number: ${i}"
done

# Number: 0
# Number: 1
# Number: 2
# Number: 3
```
