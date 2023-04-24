# UNRAID

整体网络架构

- 光猫 --桥接拨号-> 主路由（10.0.0.1）-> ALL2ONE
- `ALL IN ONE`
  - `10.0.0.7`OpenWrt作为旁路由
  - `10.0.0.8`Unraid底层服务
  - `10.0.0.9`Windows

> 网口eth0作为Unraid管理口，网口eth1~3直通

- x00~x09 基础
- x10~x19 学习
- x20~x29 影音
- x30~x39 娱乐

## UNRAID安装

### 准备

- \>= 2G的U盘
- [Unraid USB Creator](https://unraid.net/zh/%E4%B8%8B%E8%BD%BD)安装程序
- Unraid离线zip包
- 开心破解包

### 刷入

1. 打开`Unraid USB Creator`选离线包刷入
2. 替换pj文件
3. 修改U盘文件夹`EFI-`为`EFI`（因为bios设置了只uefi启动）
4. 主路由LAN网线连接eth0口，bios修改U盘为第一启动项启动

### 配置

1. 修改基本信息`Dashboard`
    - 服务名、介绍、型号、图片
2. 时间`Settings/DateTime`
    - 时区：UTC+08:00
    - NTP：
       - ntp.aliyun.com
       - ntp.tencent.com
       - time.windows.com
       - time.google.com
3. 网络设置`Settings/NetworkSettings`
    - `Bonding members of bond0`一栏只留eth0
    - `IPv4 address assignment`：静态
    - `IPv4 address`：10.0.0.8
    - `IPv4 default gateway`：10.0.0.7
    - `IPv4 DNS server`：10.0.0.7
4. 磁盘列阵`Main`
   - Disk1~Diskn 选择需要的磁盘，下方启动（按需格式化）
       - 可以提前配置`磁盘共享`设置，不然还得停止磁盘列阵
       - 可能未出现格式化按钮，可进入终端执行`lsblk`,找到对应`type`的`disk`那块硬盘，然后执行`mkfs /dev/磁盘名称`
       - 进入`Settings/DiskSettings`设置允许自动启动
5. 磁盘共享
    - `Users`：添加用户
    - `Settings/ShareSettings`：开启disk共享，关闭user共享
    - 设置对应磁盘的共享配置（不能root用户，只能用新添加的用户）
6. 直通`Tools/SysDevs`
    - 根据需要选择显卡、声卡、网口，sata目前只有控制器直通(需要每个sata对应不同服务，所以不选)
7. 自定义图标
    - 虚拟机(编辑=>XML视图=>icon属性,可能需要重启虚拟机)
    - Docker(编辑=>高级视图=>图标链接)
8. 其他
    - 插件和应用可以等安装好OpenWRT后科学再用，若先安装某些应用，比如文件管理器`Dynamix File Manager`则打开Unraid终端执行以下命令修改hosts（每次启动会恢复的）
    > wget -qO - https://raw.hellogithub.com/hosts | cat - >> /etc/hosts
    - 修改了磁盘共享可能导致某些默认路径失效，需要手动定位一下，比如VM虚拟机配置
    - `Unassigned Devices`插件，用于挂载NTFS格式硬盘

## OpenWrt

### 旁路由

unraid创建OpenWrt虚拟机，使用unraid的虚拟网口且不直通网口

- vi /etc/config/network
  1. 编辑`lan`接口，内容如下，然后重启
  2. 进入网页
     1. `DHCP配置`：network => interface => LAN => edit => DHCP Server => Ignore interface✅ && IPv6 Settings => RA-Service + DHCPv6-Service + NDP-Proxy(disabled)
     2. `防火墙配置`：network => firewall => General Settings => Enable SYN-flood protection❎

```shell
// 步骤1
config interface 'lan'
    option deuice 'eth0' // 指定网口(即unraid分配的虚拟网口)
    option proto 'static'
    option ipaddr '10.0.0.7' // 旁路由IP
    option netmask '255.255.255.0'
    option ip6assign '60'
    option gateway '10.0.0.1' // 网关
    list dns '10.0.0.1' // 指定DNS
```

### 插件安装

- system => software => update lists
    1. `luci-i18n-base-zh-cn` 中文
    2. `luci-app-ttyd` 网页终端（方便复制粘贴）
    3. [openClash](https://github.com/vernesong/OpenClash/releases)
       1. 依赖选择`nftables`(最新的OpenWrt的防火墙是基于nftables)
       2. 如遇到`dnsmasq`相关错误则先执行
       3. openClash本身的安装可以通过 system => software => upload package
       4. 在服务中没有显示，则重启试试
       5. 重新看下`DHCP配置`,以防被openWrt修改
    4. [tencent-ddns](https://github.com/Tencent-Cloud-Plugins/tencentcloud-openwrt-plugin-ddns) 腾讯云DDNS

```shell
// 步骤3.2
opkg remove dnsmasq
mv /etc/config/dhcp /etc/config/dhcp.bak
```

### 内网域名访问

- `防火墙配置`：network => firewall => Forward => accept
- `Zones`: name(lan_to_lan)、Input/Output/Forward(accept)、Covered networks(lan)
- `Nat规则`：network => firewall => NAT Rules => 新建一条（名称:内网域名访问、协议：Any、Outbound zone：lan_to_lan、Action：MASQUERADE - Automatically）

## Windows

### 安装

- 加载驱动程序(游览 => cd驱动器 => amd64 => win11)
- 网络无法跳过(按SHIFT + F10，调出命令行窗口，然后输入OOBE\BYPASSNRO)

## VSCODE(DOCKER:linuxserver/code-server)

### 插件

- Chinese
- Material Icon Theme
- Code Spell Checker 单词检查
- Indent-Rainbow 缩进颜色

### 终端

```shell
sudo apt update
sudo apt upgrade

sudo apt install zsh vim wget

# 先切换为root用户再设置shell，不然设置不上
sudo -i
chsh -s /bin/zsh 用户名
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#VSCODE打开终端面板 => 选择默认配置文件 => zsh

# 自动补全
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# ~/.zshrc
plugins=( 
    # other plugins...
    zsh-autosuggestions
)

# 高亮
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

### flutter

#### Java

```shell
sudo apt install openjdk-11-jdk
```

#### Android sdk manager

```shell
# https://developer.android.com/studio/command-line/sdkmanager?hl=zh-cn
sudo apt install unzip
unzip commlinetools-xxxx.zip
mv cmdline-tools latest
mkdir -p ~/android-sdk/cmdline-tools
mv latest ~/android-sdk/cmdline-tools/
# .zshrc
export ANDROID_HOME=$HOME/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
# sdkmanager
sdkmanager --list #显示所有可用的 SDK 包
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0" #识别最新的安卓平台（这里是 33）并运行
```

#### Gradle

```shell
# https://gradle.org/releases/
unzip gradle-xx.zip
mv gradle-xx gradle
# .zshrc
export GRADLE_HOME=$HOME/gradle
export PATH=$GRADLE_HOME/bin:$PATH

```

#### Flutter

```shell
git clone https://github.com/flutter/flutter.git -b stable
# .zshrc
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export PATH=$PATH:$HOME/flutter/bin

flutter doctor
flutter doctor --android-licenses
```


## 网心云

- 直通nvme硬盘、eth1网口(静态IP,且网关为10.0.0.1)
- 参考链接[官方](https://help.onethingcloud.com/7cb4/35e9/e609/1196)
