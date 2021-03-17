---
title: "面试题目 - 1"
date: 2021-03-15T23:10:33+08:00
tags: ["interview"]
---

> 记录一次笔试中的题目

## MySQL 中 truncate, drop, delete 的区别

摘自 [TRUNCATE TABLE vs. DELETE vs. DROP TABLE: Removing Tables and Data in SQL](https://learnsql.com/blog/difference-between-truncate-delete-and-drop-table-in-sql/)

> google 关键词: truncate drop delete mysql

### delete

`delete` 是 DML (Data Manipulation Language) 命令;

此命令从表中删除记录; 它只用于从表中删除记录, 而不是从数据库中删除表;

语法:

```sql
-- 删除表 tb_name 中的所有记录
delete from tb_name;

-- 删除表 tb_name 中满足 condition 条件的记录
delete from tb_name where condition
```

1. 如果你不想删除表结构或者仅想删除特定记录, 可使用 `delete`;
2. 此命令可以删除一个, 一些或全部记录;
3. 该命令执行成功时, 会返回此次执行中被删除记录数;
4. `delete` 命令在执行中会使用行锁且可**回滚**; 每个被删除的记录都会被锁;
5. `delete` 会保持自增 ID(auto-increment ID) 的值; 例如删除了最新的记录, 其 ID 为 20, 然后再次插入新记录, 则该记录的 ID 为 21 - 即使它前面那条记录是 19;

### truncate

`truncate` 类似于 `delete`, 但它是 DDL (Data Definition Language) 命令;

它同样可以在删除记录时保留表结构, 但并不支持 `where` 子句(即只能删除所有记录);

语法:

```sql
truncate table tb_name;
```

1. `truncate` 命令在执行后, SQL Server 和 PostgreSQL 可以回滚, **而 MySQL 和 Oracle 不支持回滚**;
2. `truncate` 速度比 `delete` 快, 因为它不会在删除之前扫描每条记录;
3. `truncate` 使用表锁, 因此该命令使用的事务空间也比 `delete` 少;
4. 不同于 `delete`, 该命令执行成功后, 不返回被删除记录数;
5. 不同于 `delete`, 该命令会重置自增 ID(auto-increment ID) 的值(通常置为 1);

   > PostgreSQL 可选择是否重置, Oracle 则不会被 `truncate` 命令重置;

### drop

`drop` 是 DDL (Data Definition Language) 命令;

它不用于简单地删除表中的记录, 而是用于删除表结构, 及其所有存储在表中的记录;

语法:

```sql
drop table tb_name;
```

1. `drop` 命令会删除表定义及记录, 同时还有索引 (index), 约束 (constraints) 和触发器 (trigger);
2. `drop` 会释放存储空间;
3. 当执行 `drop` 命令时, 不会触发 triggers;
4. **在 MySQL 中, 该命令不可回滚**; 而在 Oracle, SQL Server 和 PostgreSQL 是可回滚的;

### 总结

> 该表格完全从文章中拷贝

|                              | DELETE                             | TRUNCATE                                                            | DROP                                                                      |
| :--------------------------- | :--------------------------------- | :------------------------------------------------------------------ | ------------------------------------------------------------------------- |
| **Type**                     | DML                                | DDL                                                                 | DDL                                                                       |
| **Uses a lock**              | Table lock                         | Row lock                                                            | Table lock                                                                |
| **Works in WHERE**           | Yes                                | No                                                                  | No                                                                        |
| **Removes ...**              | One, some, or all rows in a table. | All rows in a table.                                                | Entire table structure: data, privileges, indexes, constraints, triggers. |
| **Resets ID auto-increment** | No                                 | MySQL: Yes Oracle: No PostgreSQL: User decides SQL Server: Yes      | Doesn’t apply                                                             |
| **Rollback**                 | Yes                                | MySQL: No<br />Oracle: No<br />PostgreSQL: Yes<br />SQL Server: Yes | MySQL: No<br />Oracle: Yes<br />PostgreSQL: Yes<br />SQL Server : Yes     |
| **Transaction logging**      | Each row                           | Whole table (minimal)                                               | Whole table (minimal)                                                     |
| **Works with indexed views** | Yes                                | No                                                                  | No                                                                        |
| **Space requirements**       | More space                         | Less space                                                          | More space                                                                |
| **Fires triggers**           | Yes                                | No                                                                  | No                                                                        |
| **Speed**                    | Slow                               | Fastest                                                             | Faster                                                                    |

### 其它文章

[drop、truncate 和 delete 的区别](https://www.cnblogs.com/zhizhao/p/7825469.html)

[MySQL 之 drop、truncate 和 delete 的区别](https://juejin.cn/post/6844904122655883272)

## GET, POST, PUT 的区别

摘自 _<图解 HTTP>_

- GET: **获取**资源; 用来请求访问 URI 指定的资源; 指定的资源经服务器解析后返回相应内容;
- POST: **传输**实体的主体; 虽然 GET 也可以传输, 但一般不用 GET, 而是用 POST; POST 的功能和 GET 很相似, 但 POST 的主要目的不是获取资源;
- PUT: 传输**文件**;

## HTTP1.0, HTTP1.1, HTTP2.0 的区别

[HTTP/2 相比 1.0 有哪些重大改进？](https://www.zhihu.com/question/34074946)

## 编程题 1

给出数据结构如下面的数组;

id 表示该菜单自身的唯一标识, parent_id 表示父级菜单的唯一表示, name 是菜单名;

> 顶级菜单的唯一标识固定为 0;

```json
[
  { "id": 1, "parent_id": 0, "name": "菜单1" },
  { "id": 2, "parent_id": 1, "name": "菜单1.1" },
  { "id": 3, "parent_id": 2, "name": "菜单1.1.1" },
  { "id": 4, "parent_id": 2, "name": "菜单1.1.2" },
  { "id": 5, "parent_id": 4, "name": "菜单1.1.2.1" },
  { "id": 6, "parent_id": 0, "name": "菜单2" },
  { "id": 7, "parent_id": 6, "name": "菜单2.1" },
  { "id": 8, "parent_id": 2, "name": "菜单1.1.3" },
  { "id": 9, "parent_id": 6, "name": "菜单2.2" }
]
```

要求: 打印出类似如下的结构;

```
- 菜单1
-- 菜单1.1
--- 菜单1.1.1
--- 菜单1.1.2
---- 菜单1.1.2.1
--- 菜单1.1.3
- 菜单2
-- 菜单2.1
-- 菜单2.2
```

实现:

```javascript
/** @type {Map<number, unknown>} */
const idToMenuMap = new Map();
idToMenuMap.set(0, { id: 0, parent_id: null, name: "" });

/** @type {Map<number, unknown[]>} */
const idToSubMenuMap = new Map();

for (const item of menuList) {
  idToMenuMap.set(item.id, item);

  if (!idToSubMenuMap.has(item.parent_id)) {
    idToSubMenuMap.set(item.parent_id, [item.id]);
  } else {
    idToSubMenuMap.get(item.parent_id).push(item.id);
  }

  if (!idToSubMenuMap.has(item.id)) {
    idToSubMenuMap.set(item.id, []);
  }
}

const print = (id, level = 0) => {
  const menu = idToMenuMap.get(id);
  if (level !== 0) {
    console.log("-".repeat(level) + " " + menu.name);
  }

  const subMenuList = idToSubMenuMap.get(id);
  for (const sub of subMenuList) {
    print(sub, level + 1);
  }
};

print(0);
```

## 编程题 2

完全就是 LeetCode 中的 [16. 3Sum Closest](https://leetcode.com/problems/3sum-closest/);

故此处不讲解;
