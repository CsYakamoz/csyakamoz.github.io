---
title: "ssh_config"
date: 2023-03-27T23:40:30+08:00
tags: ["shell"]
---

> `man ssh_config`

`ssh_config – OpenSSH client configuration file`

ssh 从如下位置**按顺序**获取配置:

1. command-line options
2. user's configuration file (~/.ssh/config)
3. system-wide configuration file (/etc/ssh/ssh_config)

## 常见选项

- `Host`: 指定对应的远程主机名或 IP 地址, 可以使用通配符 `*`;

- `HostName`: 指定远程主机的主机名或 IP 地址;

- `User`: 用户名;

- `Port`: 端口;

- `IdentityFile`: 指定用于身份验证的私钥文件的路径;

- `ControlMaster`: 是否启用 SSH 连接复用功能, 可选值为: `yes` or `no`, 默认为 `no`;

- `ControlPath`: 指定用于保存 SSH 连接的 control-socket 路径;

- `ControlPersist`: 所有 SSH 连接都关闭后, 是否保持 control-socket 开启, 值可以为: `yes` or `no` or `number`, 其中 number 是指秒数, 默认值为 `no`;

## Demo

```sshconfig
Host foo
    Hostname 127.0.0.1
    User foo
    Port 8888
    IdentityFile ~/.ssh/foo_id_rsa
    ControlMaster yes
    ControlPath ~/.ssh/socket/%C
    ControlPersist 60

Host bar
    Hostname 127.0.0.1
    User bar
    Port 9999
    IdentityFile ~/.ssh/bar_id_rsa
    ControlMaster yes
    ControlPath ~/.ssh/socket/%C
    ControlPersist 37
```

此时我可以通过命令 `ssh foo` or `ssh bar` 登录对应的远程主机

## 参考

[SSH Config 那些你所知道和不知道的事](https://deepzz.com/post/how-to-setup-ssh-config.html)
