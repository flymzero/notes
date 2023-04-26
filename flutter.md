# flutter

## linux

### java
```
sudo apt install openjdk-11-jdk
```
### Android sdk manager
- [下载文件](https://developer.android.com/studio/command-line/sdkmanager?hl=zh-cn)

```shell
sudo apt install unzip

# 解压重名
unzip commlinetools-xxxx.zip
mv cmdline-tools latest

# 移动
mkdir -p ~/android-sdk/cmdline-tools
mv latest ~/android-sdk/cmdline-tools/

# 配置
echo -e '\n# android\nexport ANDROID_HOME=~/android-sdk\nexport PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin\nexport PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.zshrc
source ~/.zshrc

# sdkmanager
sdkmanager --list #显示所有可用的 SDK 包
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0" #识别最新的安卓平台（这里是 33）并运行
```

### Gradle

- [下载文件](https://gradle.org/releases/)

```shell
# 解压重名
unzip gradle-xx.zip
mv gradle-xx gradle

# 配置
echo -e '\n# gradle\nexport GRADLE_HOME=$HOME/gradle\nexport PATH=$GRADLE_HOME/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```

### Flutter
```shell
git clone https://github.com/flutter/flutter.git -b stable

# 配置
echo -e '\n# flutter\nexport PUB_HOSTED_URL=https://pub.flutter-io.cn\nexport FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn\nexport PATH=$PATH:$HOME/flutter/bin' >> ~/.zshrc
source ~/.zshrc

# 检测
flutter doctor
flutter doctor --android-licenses
```
