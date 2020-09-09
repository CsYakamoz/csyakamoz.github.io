---
title: "Node.js 调用微信小程序图片校验接口"
date: 2020-09-09T10:21:33+08:00
tags: ["javascript"]
---

```javascript
const fs = require("fs");
const request = require("request");

request.post(
  {
    uri:
      "https://api.weixin.qq.com/wxa/img_sec_check?access_token=ACCESS_TOKEN",

    formData: {
      // 方法 1
      media: fs.createReadStream("path_to_img"),

      // 方法 2
      attachments: [
        // 只认下标为 0 的
        fs.createReadStream("path_to_img"),

        // 下标 1 及之后的会被微信忽略
        ...,
      ],

      // 方法 3
      media: {
        value: buffer,
        options: {
          // 必须有 filename, 值可任意但不能为空串
          filename: "default",
          // contentType 可有可无, 且值任意
          contentType: "image/jpeg",
        },
      },

      // 方法 4
      media: request.get("uri_to_img"),
    },
  },
  (error, resp, body) => {
    if (error) {
      console.log(error);
      return;
    }

    console.log(body);
  }
);
```

方法 1, 2 的使用场景: 文件在本地

方法 3 的使用场景: 参数是图片的 base64 内容, 在调用微信接口前, 将其转换成 Buffer

方法 4 的使用场景: 知道图片资源的 uri

## 参考

[Wechat security.imgSecCheck](https://developers.weixin.qq.com/miniprogram/dev/api-backend/open-api/sec-check/security.imgSecCheck.html)

[npm request](https://www.npmjs.com/package/request#multipartform-data-multipart-form-uploads)

[后端使用 nodejs, API 接口: security.imgSecCheck 如何才能正确调用?](https://developers.weixin.qq.com/community/develop/doc/000486c0fbc558719d89a281c51800)
