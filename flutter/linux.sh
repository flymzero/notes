#!/bin/bash
echo -e "\nlinux相关安装脚本\n"

# 软件是否已安装，若未安装则安装
# $1: 实际软件名
# $2: 安装软件名（若空则用$1）
function installSoft(){
    if [ -z "$(command -v $1)" ]; then
        name=$1 
        if [ -n "$2" ]; then
            name=$2
        fi
        sudo apt install $name
    fi
}

echo -e "请选择：\n  0.切换国内源\n  1.安装golang\n  2.安装flutter\n"
read -s -n 1 installNumber

# 切换国内源
if [ $installNumber = 0 ]; then
    echo -e "切换国内源前置条件：\n  1.需使用 Root 用户执行脚本(sudo -i)\ny:确认 n:退出\n"
    read -s -n 1 sure
    if [ $sure = y ]; then
        installSoft curl
        bash <(curl -sSL https://linuxmirrors.cn/main.sh)
    else
        exit 1
    fi
fi

# 安装golang
if [ $installNumber = 1 ]; then
    echo -e "golang安装前置条件：\n  1.当前sh为fish\n  2.go.tar.gz文件已在脚本同目录下(链接：https://go.dev/dl/)\ny:确认 n:退出\n"
    read -s -n 1 sure
    if [ $sure = y ]; then
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf go.tar.gz
        echo -e '\n# golang\nset -x PATH /usr/local/go/bin $PATH;' >> ~/.config/fish/config.fish
        source ~/.config/fish/config.fish
        /usr/local/go/bin/go env -w GO111MODULE=on
        /usr/local/go/bin/go env -w GOPROXY=https://goproxy.cn,direct
    else
        exit 1
    fi
fi

# 安装flutter
if [ $installNumber = 2 ]; then
    echo -e "flutter安装前置条件：\n  1.当前sh为fish\n  2.gradle.zip已在脚本同目录下（链接：https://gradle.org/releases/）\n  3.commandlinetools.zip已在脚本同目录下(链接：https://developer.android.com/studio/command-line/sdkmanager?hl=zh-cn)\ny:确认 n:退出\n"
    read -s -n 1 sure
    if [ $sure = y ]; then
        installSoft java openjdk-17-jdk
        installSoft unzip

        #-----------------cmdline-tools
        # 解压重名
        unzip commandlinetools.zip
        mv cmdline-tools latest
        # 移动
        mkdir -p ~/.android-sdk/cmdline-tools
        mv latest ~/.android-sdk/cmdline-tools/
        # 配置fish
        echo -e '\n# android\nset -x ANDROID_HOME $HOME/.android-sdk;\nset -x PATH $ANDROID_HOME/cmdline-tools/latest/bin $PATH;\nset -x PATH $ANDROID_HOME/platform-tools $PATH;' >> ~/.config/fish/config.fish
        source ~/.config/fish/config.fish
        # sdkmanager
        ~/.android-sdk/cmdline-tools/latest/bin/sdkmanager --list #显示所有可用的 SDK 包
        ~/.android-sdk/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0" #识别最新的安卓平台（这里是 33）并运行

        #-----------------gradle
        # 解压重名
        uName=$(unzip -l gradle.zip | awk '{if(NR == 4){ print $4}}')
        unzip gradle.zip
        mv $uName .gradle
        # 配置fish
        echo -e '\n# gradle\nset -x GRADLE_HOME $HOME/.gradle;\nset -x PATH $GRADLE_HOME/bin $PATH;' >> ~/.config/fish/config.fish
        source ~/.config/fish/config.fish

        #-----------------flutter
        installSoft git
        git clone https://github.com/flutter/flutter.git -b stable ~/.flutter
        # 配置fish
        echo -e '\n# flutter\nset -x PUB_HOSTED_URL https://pub.flutter-io.cn;\nset -x FLUTTER_STORAGE_BASE_URL https://storage.flutter-io.cn;\nset -x PATH $HOME/.flutter/bin $PATH;' >> ~/.config/fish/config.fish
        source ~/.config/fish/config.fish
        # 检测
        ~/.flutter/bin/flutter doctor
        ~/.flutter/bin/flutter doctor --android-licenses
    else
        exit 1
    fi
fi

