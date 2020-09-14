---
title: "Xor Cipher - 异或加密的应用场景之一"
date: 2020-09-09T13:24:09+08:00
tags: ["algorithm"]
---

异或加密是一种简单的加密算法。

具体内容请看下列文章：

- [XOR cipher](https://en.wikipedia.org/wiki/XOR_cipher)
- [XOR 加密简介](http://www.ruanyifeng.com/blog/2017/05/xor.html)

本文只讨论个人所应用到的场景。

## 需求

在工作中，个人经常遇到使用 [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier) 作为各种对象 ID 的场景。

例如：对于每一个 song，我们都为其生成唯一的 quiz，song & quiz 的 ID 都是 uuid；因此，每一个 song 都和其唯一的 quiz 绑定。

需求是：songId & quizId 可以双向查找；即，可通过 songId 查找到对应的 quizId，也可通过 quizId 查找到对应的 songId。

## 解决方案

### 方案 0 - 数据库存储映射

两种存储方式：

1. song 表添加 `quizId` 列，quiz 表则添加 `songId` 列
2. 建立新表 `song-quiz`, songId 和 quizId 作为联合主键

### 方案 2 - 异或加密当作映射

如果不想将映射关系存到数据库中，则可以使用异或加密。

使用异或后，我们所需存储的仅有 `key`。

Wiki 上有 python 的实现方案，这里则展示 Node.js 的实现方案。

```javascript
/**
 * @param {'ascii' | 'utf8' | 'utf16le' | 'ucs2' | 'base64' | 'latin1' | 'binary' | 'hex'} encoding 编码格式
 * @param {string} key  密钥
 * @param {string} text 待加密（解密）的文本
 * @returns {string} 加密（解密）后的文本
 */
function XorCipher(encoding, key, text) {
  if (typeof text !== "string" || typeof key !== "string") {
    throw new Error("both of key and text should be string type");
  }

  const bufKey = Buffer.from(key, encoding);
  const bufText = Buffer.from(text, encoding);

  if (bufText.length === 0) {
    throw new Error("after encoding, text's length should be greater than 0");
  }
  if (bufKey.length === 0) {
    throw new Error("after encoding, key's length should be greater than 0");
  }

  if (bufText.length > bufKey.length) {
    throw new Error(
      "after encoding, text's length should be less than or equal to key's length"
    );
  }

  let message = Buffer.alloc(0);
  for (let i = 0; i < bufText.length; i++) {
    const c = bufKey[i] ^ bufText[i];
    message = Buffer.concat([message, Buffer.from([c])]);
  }

  return message.toString(encoding);
}
```

使用案例：

```javascript
const songId = "8e5c1e81a29143efb2cefefe08259a13";
const key = "fc5c69ef3e874082a25448e925df1364";
const quizId = XorCipher("hex", key, songId);

console.log(quizId); // "7200776e9c16036d109ab6172dfa8977"
console.log(XorCipher("hex", key, quizId) === songId); // true
```

## 总结

利用异或，我们只需要还记得 **key**, 就能做到各种各样的映射（当然数据库也行）。

例如：

```text
          key1               key2              key3
id1 <============> id2 <============> id3 <============> id4

or

     k1  id2
      ↗
id1
      ↘
     k2  id3
```
