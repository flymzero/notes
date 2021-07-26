# ESXI

## 前提
- 本来想用esxi+openwrt做旁路由，发现不少问题，回流、硬路由本身关系等不完美，所有放弃之。   
- 所以重新搭建一下esxi+openwrt做做主路由，硬路由做二级路由，再加上一些其他东西，顺便当做备忘录。
- 基于esxi7.0，后续版本可能不完全适用
```
openwrt: 10.0.0.1
esxi: 10.0.0.2
二级硬路由: 10.0.0.3(10.0.1.1)
debian: 10.0.0.4
windows: 10.0.0.5
nas: 10.0.0.6

4个千兆网口：0，1，2，3
    - 0口：作为esxi管理后台的网口
    - 1口：直通，作为openwrt的WAN口
    - 2口：直通，作为openwrt的LAN口
    - 3口：直通，作为openwrt的LAN口
```

## 硬件
- j4125 + 16G内存 + 500G(nvme-m2) + 120G(sata,反正闲杂)

## 准备
- 电脑 & U盘
- esxi镜像[下载链接](https://my.vmware.com/zh/web/vmware/evalcenter?p=vsphere-eval-7)
- nvme驱动(esxi7.0后很多驱动不支持，需要用6.5镜像里面的驱动替换)[下载链接](TODO)
- iso镜像修改工具：windows下[UltraISO](https://www.ultraiso.com/)
- U盘引导工具：windows下[Rufus](https://rufus.ie/zh/)
- openwrt固件
    - [精品小包](https://drive.google.com/open?id=1eyIxVfyzO4nyzaT1sSr6xWf50_5YJN7g)
    - [高大全](https://drive.google.com/drive/folders/1PsS3c0P7a4A4KY8plQg4Fla8ZI-PGBb1?usp=sharing)

## 安装

### 1. nvme驱动
- 把6.5的nvme驱动文件改名为NVME_PCI.V00，使用UltraISO替换掉7.0镜像里面的同名文件

### 2. 制作u盘引导(Rufus)

### 3. 修改物理机BIOS
- BIOS中关闭CSM(使其只支持UEFI启动)，Advanced > CSM Configuration > Disable

### 4.安装
1. 修改虚拟闪存
    1. 在安装时ESXI 7.0启动的第一个画面，按shift + O(字母o)组合键，速度要快。
    2. 进入命令行后，在 cdromBoot runweasel (有空格)后输入autoPartitionOSDataSize=x(x代表MB,比如8GB就把x替换为8192)，然后按回车执行后续正常安装步骤。

2. 配置网络   
安装完成后重启，按F2进入配置
    - 设置对应的esxi管理网口(一般第一个网口)
    - 设置静态ip(10.0.0.2),设置网关(10.0.0.1)
    - 设置DNS服务(10.0.0.1)，hostName(ESXI)

3. 系统配置  
电脑网线连接esxi物理网口，并配置ip，浏览器进入管理后台
    - 添加许可证：管理 > 许可证
    - 添加硬盘：存储 > 设备 > 新建数据存储(可能需要删除分区)
    - 网口直通：除esxi管理网口，其他网卡直通，管理 > 硬件 > PCI设备(筛选直通) > 勾选其他3个网口 > 切换直通 > 重新引导主机(之后物理网卡应该只有一个了)
    - 虚拟交换机：vSwitch0 > 编辑 > 安全 > 全接受

4. openwrt
    - 创建虚拟机时，需要把内存里面的（预留所有客户机内存）前面打上勾(因为网卡直通了)
    - 添加开机自启动
    - 启动后，网络 > 接口(把1口设置为WAN口，其他0,2,3设置为LAN口+桥接)
    - 虚拟机和硬路由都设置静态ip好了，方便管理（不是必须）

## 5.常见问题
- 虚拟机没有自启动
> 首先虚拟机本身要设置自启动，并且在主机 > 管理 > 系统 > 自动启动 > 编辑(已启动:是)

- 局域网无法通过域名访问
> 网络 > DHCP/DNS > 自定义挟持域名 



