# UNRAID

## 网络

- 一级路由：`10.0.0.1`
- 二级路由(OpenWrt旁路由模式)：`10.0.0.7`
- UNRAID：`10.0.0.8`
- 群辉：`10.0.0.9`
- Windows: `10.0.0.10`

## U盘

- 容量大于2G
- GUID通过官方的[Unraid USB Creator](https://unraid.net/zh/%E4%B8%8B%E8%BD%BD)获取，通过系统获取的对不上

## OpenWrt定制

- [在线自定义地址](https://supes.top/)
  - 型号：`Generic x86/64`
  - 常用软件包：`luci-app-ddns 动态域名解析`,`luci-app-eqos IP限速`,`luci-app-wrtbwmon 流量监控`,`tailscale`
  - 互联网：`OpenClash`
  - 后台地址：`10.0.0.7`
  - 旁路由模式（关闭DHCP）
  - IPv4网关：`10.0.0.1`