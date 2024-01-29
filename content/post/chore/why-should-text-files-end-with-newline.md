---
title: "为何文本文件应该以换行符结尾?"
date: 2023-11-05T01:03:34+08:00
tags: ["unix"]
---

很多 Linter 都会因文件不是以换行符结尾而做出 Warning/Error 提示

- JavaScript_ESLint: [eol-last](https://eslint.style/rules/js/eol-last)

  > NewLine required at end of file but not found

- PHP_PSR-2: [Files](https://www.php-fig.org/psr/psr-2/#22-files)

  > Expected 1 newline at end of file; 0 found

- Git Commit or Log or Diff:

  ```
  \ No newline at end of file
  ```

查了下资料, 原因是 Unix Standard 对于 Lines 的定义:

> 3.206 Line
>
> A sequence of zero or more non- \<newline\> characters plus a terminating \<newline\> character.

基于以上定义, 如果文本文件不是以换行符结尾, 那么在某些工具上可能会出问题.

例如引用中所举的例子:

```sh
$ cat a.txt
foo

$ cat b.txt
bar
$ cat c.txt
baz

$ cat {a,b,c}.txt
foo
barbaz

$ wc -l b.txt
0

$ cat {a,b,c}.txt | wc -l
2
```

Reference:

- [Why should text files end with a newline?](https://gist.github.com/OleksiyRudenko/d51388345ea55767b7672307fe35adf3)
- [Mail Archive - Re: no newline at end of file](https://gcc.gnu.org/legacy-ml/gcc/2001-07/msg01120.html)
