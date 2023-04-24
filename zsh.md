# zsh

## 安装zsh
```
sudo apt install zsh
```

## 设置默认shell
```
chsh -s /bin/zsh
```

## 安装Oh My Zsh
```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
### 插件

- `zsh-syntax-highlighting` 突出高亮
```shell
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

- `zsh-autosuggestions` 自动补全
```shell
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

> 最后在`.zshrc`中的`plugin栏`添加对应的`插件名`



