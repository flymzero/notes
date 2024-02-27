# nvim安装教程

### nvim安装
```shell
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract

./squashfs-root/AppRun --version # 查看版本

sudo mv squashfs-root /usr/local/
sudo ln -s /usr/local/squashfs-root/AppRun /usr/bin/nvim
nvim
```

### 字体

下载 [Caskaydia Cove Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip)

安装文件夹内所有字体，并配置对应终端软件的字体

测试：