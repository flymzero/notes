echo -e '\n# android\nexport ANDROID_HOME=/usr/local/android\nexport PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin\nexport PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.zshrc

echo -e '\n# gradle\nexport GRADLE_HOME=/usr/local/gradle\nexport PATH=$GRADLE_HOME/bin:$PATH' >> ~/.zshrc

echo -e '\n# flutter\nexport PUB_HOSTED_URL=https://pub.flutter-io.cn\nexport FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn\nexport PATH=$PATH:/usr/local/flutter/bin' >> ~/.zshrc



sudo apt -y install openjdk-17-jdk

ANDROID_SDK_TOOLS_VERSION=11076708
ANDROID_HOME=/usr/local/android

sudo mkdir -p /usr/local/android/cmdline-tools/latest

wget https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip -O /tmp/android-sdk-tools.zip

unzip -q /tmp/android-sdk-tools.zip -d /tmp/

sudo mv /tmp/cmdline-tools/* ${ANDROID_HOME}/cmdline-tools/latest/

sudo chmod -R a+w /usr/local/andorid

sdkmanager --licenses
sdkmanager --install "platform-tools" "platforms;android-33" "build-tools;33.0.0"


GRADLE_VERSION=7.5
sudo mkdir /usr/local/gradle
wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip -O /tmp/gradle.zip
unzip -q /tmp/gradle.zip -d /tmp/
sudo mv /tmp/gradle-${GRADLE_VERSION}/* /usr/local/gradle/
sudo chmod -R a+w /usr/local/gradle



sudo git clone --depth 1 https://github.com/flutter/flutter.git -b stable /usr/local/flutter
git config --global --add safe.directory /usr/local/flutter
sudo chmod -R a+w /usr/local/flutter