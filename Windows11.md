# Windows11

## 激活

- [Microsoft-Activation-Scripts](https://github.com/massgravel/Microsoft-Activation-Scripts)

## 设置

- Windows更新 => 高级选项 => 接收其他Windows产品更新 （用于比如wsl等更新）

## 启动或关闭Windows功能

- `Telnet客户端` 调试使用
- `适用于 Linux 的 Windows 子系统` wsl需要
- `虚拟机平台` wsl需要

## 防火墙

- `Windows安全中心` 可能应用被防火墙拦截 => 防火墙和网络保护 => 允许应用通过防火墙 => 配置下

## 防休眠
```shell
# 终端执行
powercfg.exe /hibernate off
```
- `设置` => `系统` => `电源` => `屏幕和睡眠` => 睡眠状态：从不

## winget

- [winget](https://learn.microsoft.com/zh-cn/windows/package-manager/winget/)

## wsl2

- [wsl2](https://learn.microsoft.com/zh-cn/windows/wsl/)

1. 开启`适用于 Linux 的 Windows 子系统`功能
2. 以管理员身份运行终端
3. `wsl --update` 更新内核
4. `wsl --install`  安装 WSL 和 Linux 的默认 Ubuntu 发行版
    - `-d`  指定要安装的 Linux 发行版（通过运行 `wsl --list --online` 来查找可用的发行版。）
5. `Ubuntu`
    - `sudo apt update && sudo apt upgrade` 更新依赖
    - `sudo apt purge openssh-server` 卸载openssh服务（可能存在）
    - `sudo apt install openssh-server` 安装最新的openssh服务
    - 编辑`sshd_config`文件
        ```shell
        sudo vim /etc/ssh/sshd_config

        # 避免和windows的22端口冲突
        Port 2222
        ListenAddress 0.0.0.0
        ListenAddress ::
        # 允许使用密码进行登陆
        PasswordAuthentication yes
        ```
    - `sudo service ssh --full-restart` 重启ssh服务
    - ssh开机自启
        ```shell 
        sudo vim /etc/init.wsl

        # 内容
        #! /bin/sh
        service ssh start

        # 赋予文件可执行权限
        sudo chmod +x /etc/init.wsl
        ```
6. windows代理端口(管理员模式)
    ```shell
    # linux_ip: ip a查看
    # linux_port: sshd_config配置的Port
    netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=2222 connectaddress=[linux_ip] connectport=[linux_port]
    ```
7. `入站规则` : 高级安全 Windows Defender 防火墙 => 入站规则 => 新建规则 => 协议TCP/端口2222等
8. `wsl开机自启`： 新建 `linux-start.vbs` => 按`win+R`输入`shell:startup`将以上vbs文件放入该目录
    ```vbs
    Set ws = WScript.CreateObject("WScript.Shell")        
    ws.run "wsl -d [Linux发行版名称] -u root /etc/init.wsl", vbhide
    ```


## wsa
- [wsa](https://learn.microsoft.com/zh-cn/windows/android/wsa/)