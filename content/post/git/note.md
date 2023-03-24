---
title: "Git 笔记"
date: 2020-09-09T16:29:42+08:00
tags: ["git"]
---

## 初始化

```sh
git config --global user.name "your name"
git config --global user.email "yourEmail@example.com"
```

## 文件的状态

- 未跟踪 (untracked)
- 已跟踪 (tracked)
  - 未修改 (unmodified)
  - 已修改 (modified)
  - 已暂存 (staged)
  - 已提交 (committed)

> 未修改和已提交本质上是同一种状态

## 三个工作区域

- 工作目录 (Working Directory)
- 暂存区域 (Staging Area)
- 仓库 (Repository)

## gitignore

1. 开头结尾皆无 `/`, 表示忽略所有符合规则的文件或目录；

2. 以 `/` 结尾表示忽略目录，`dist/` 即忽略所有 dist 目录；

3. 以 `/` 开头表示忽略相对于根目录的目标，`/.setting` 即忽略根目录下的 .setting 文件或目录，`/dist/` 即忽略根目录下的 dist 目录；

4. `!` 开头表示取反，即忽略指定模式以外的文件或目录；

### glob

1. `*` 匹配任意数量的任意字符：

   `Law*`, 匹配 `Law`, `Laws`, `Lawyer`, 但不匹配 `GrokLaw`, `La`, `aw`

2. `?` 匹配任意一个字符：

   `?at` 匹配 `Cat`, `cat`, `Bat`, `bat`, 但不匹配 `at`

3. `[]` 匹配给定字符集里的一个字符：

   `[CB]at` 匹配 `Cat`, `Bat`, 但不匹配 `cat`, `bat`

## 查看提交信息 (git log)

- `-p` 用来显示每次提交的内容差异
- `-n` n 为数字，意味着仅显示最近 n 次提交
- `--stat` 查看每次提交的简略统计信息

## 修改最新提交的信息

常用于修改 commit-message

```sh
git commit --amend --only
# or
git commit --amend --only -m 'xxxxxxx'
```

但个人习惯这么做：

```sh
git reset HEAD^ --soft

git commit -m 'xxxxxxx'
```

## 回滚 (git reset)

```sh
# 回滚，并忽略所有改动
git reset commit-id --hard

# 回滚，但暂存所有改动
git reset commit-id --soft
```

## 储藏 (git stash)

储藏所有已跟踪文件的改动

```sh
# 储藏当前改动，储藏信息为当前提交信息 (commit message)
git stash [push]

# 储藏当前改动，并指定储藏信息
git stash push 'message'

# 储藏当前改动（包括未跟踪的文件）
git stash push -u

# 仅储藏已暂存的文件
git stash push --keep-index

# 应用并删除最新的储藏
git stash pop

# 应用特定的储藏
git stash apply stash@{n}

# 删除特定的储藏, n 为数字
git stash drop stash@{n}

# 查看所有储藏
git stash list
```

## 找回已删除的 stash

原文: https://gist.github.com/joseluisq/7f0f1402f05c45bac10814a9e38f81bf

这里仅做一份副本:

1. Find the stash commits

   ```sh
   git log --graph --oneline --decorate $( git fsck --no-reflog | awk '/dangling commit/ {print $3}' )
   ```

2. Once you know the hash of the commit you want, you can apply it as a stash

   ```sh
   git stash apply YOUR_WIP_COMMIT_HASH_HERE
   ```

## 将其它分支的某个(些)提交的改动应用于当前分支

```sh
git cherry-pick <commitHash>...
```

Notice: 新提交的哈希值与原来的不同

个人常用的选项:

`-x`: 在提交信息的末尾追加一行 `(cherry picked from commit ...)`, 方便以后查到这个提交是如何产生的;

`-s`: 在提交信息的末尾追加一行操作者的签名, 表示是谁进行了这个操作;

其它使用方法可参考: [阮一峰的网络日志 - git cherry-pick 教程](http://www.ruanyifeng.com/blog/2020/04/git-cherry-pick.html) 或者 `git cherry-pick --help`

## 本地分支重命名

```sh
git branch -m <old-name> <new-name>

git branch -m <new-name>
```

## Git Worktree

[官方文档](https://git-scm.com/docs/git-worktree)介绍:

> Manage multiple working trees attached to the same repository.
>
> A git repository can support multiple working trees, allowing you to check out more than one branch at a time.

### add

`git worktree add [-d] <path> [branch]`: 用于新增 `working tree`.

- `path`: 该 `working tree` 的所处位置;
- `branch`: 新增 `working tree` 的所属分支. 如果没有 `branch` 参数, 则创建新的分支 - 分支名为 `path` 的最后组成部分;
- `-d`: 用于新增可随时丢弃(不与任何分支相关联)的 `working tree`;

个人使用如下:

假设项目名叫 `foobar`, 那么个人会将 `master` 分支克隆到 `foobar/master`;

同时, 在 `master` 目录下执行 `git worktree add ../dev dev` 以及 `git worktree add ../main your-feature`;

master/dev 分别管理着正式/测试环境的代码, main 主要用来进行 feature 开发;

> 这三个 `working trees` 都连着同一个 git 仓库, 所以 stash 是**共同的**;

### remove

`git remove [--force] <worktree>`

当 worktree 是干净时, 可以直接用该命令删除, 否则使用 `--force` 来强制删除

> 干净的定义是无未跟踪的文件, 或者已跟踪的文件无修改

## 常见的配合 shell 脚本使用的命令

1. 获取仓库根目录

   ```sh
   git rev-parse --show-toplevel
   ```

2. 判断当前目录是否属于仓库

   ```sh
   git rev-parse --is-inside-work-tree
   ```

3. 获取当前分支名

   ```sh
   git rev-parse --abbrev-ref HEAD

   # or with Git 2.22 and above
   git branch --show-current
   ```
