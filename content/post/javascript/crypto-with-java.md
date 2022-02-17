---
title: "Nodejs 与 Java 的加解密"
date: 2021-04-02T23:55:18+08:00
tags: ["nodejs", "crypto"]
---

## 问题

最近在对接第三方接口, 对方是用 Java 写的 rsa 加密;

> 其提供的加解密 Demo 类似于此[链接](https://blog.csdn.net/mshootingstar/article/details/56496719)中的 RSAUtils 类

个人选择使用 [node-rsa](https://www.npmjs.com/package/node-rsa) 进行解密;

然而, 在尝试解密过程中, 总是报各种错误, 且根据错误去 google 也无法找到解决方案;

最后无意中找到一篇[文章](https://www.cnblogs.com/davidwang456/p/8805872.html), 其说明了为什么解密失败;

> 吐槽下, google 关键词居然是 `Node RSA Java`, 难以置信 😑

## 原因

### node-rsa for javascript

```javascript
new NodeRSA([keyData, [format]], [options]);
```

options 参数中的 **encryptionScheme** 是用来指定 `padding`;

其支持两种: `pkcs1_oaep` 和 `pkcs1`, 若未指定, 则默认是前者;

### Cipher for Java

```java
// Demo 中所指定的加密方案
KeyFactory keyFactory = KeyFactory.getInstance("RSA");

// keyFactory.getAlgorithm() 返回 "RSA"
Cipher cipher = Cipher.getInstance(keyFactory.getAlgorithm());
```

`Cipher` 文档如下:

> In order to create a Cipher object, the application calls the Cipher's getInstance method, and passes the name of the requested transformation to it. Optionally, the name of a provider may be specified.
>
> A transformation is a string that describes the operation (or set of operations) to be performed on the given input, to produce some output. A transformation always includes the name of a cryptographic algorithm (e.g., AES), and may be followed by a feedback mode and padding scheme.
>
> A transformation is of the form: "algorithm/mode/padding" or "algorithm"
>
> in the latter case, provider-specific default values for the mode and padding scheme are used

以及

`Cipher.getInstance` 该函数文档如下:

> `public static final Cipher getInstance(String transformation)`
>
> This method traverses the list of registered security Providers, starting with the most preferred Provider.

`Cipher.getInstance` 的参数为 `RSA`, 无法知道它相当于指定了哪个 `Provider`, 故也不知道 `padding` 是哪个;

好巧不巧, 第三方公司的 Java 默认是 `pkcs1`;

### 总结

第三方公司的加解密代码在调用 `Cipher.getInstance` 时, 传递的是 `algorithm` 而不是 `algorithm/mode/padding`, 这导致 `mode` 和 `padding` 依赖于 Java 实现;

恰好第三方公司的 Java 实现默认是 `pkcs1` 而 `node-rsa` 默认是 `pkcs1_oaep`;

## 解决方案

I do not know.

## 参考

[Stack Overflow - RSA Java encryption and Node.js decryption is not working](https://stackoverflow.com/questions/34835582/rsa-java-encryption-and-node-js-decryption-is-not-working)

[Stack Overflow - Which padding is used by javax.crypto.Cipher for RSA](https://stackoverflow.com/questions/32033804/which-padding-is-used-by-javax-crypto-cipher-for-rsa)

[Cipher (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/index.html?javax/crypto/Cipher.html)
