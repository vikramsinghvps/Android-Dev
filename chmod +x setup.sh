#!/bin/bash
# filepath: /workspaces/Android-Dev/setup.sh

set -e

echo "Updating package lists..."
sudo apt-get update

echo "Installing system dependencies..."
sudo apt-get install -y wget unzip git curl xz-utils libglu1-mesa openjdk-17-jdk

# Install Flutter SDK
if [ ! -d "$HOME/flutter" ]; then
  echo "Installing Flutter SDK..."
  wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.1-stable.tar.xz
  tar xf flutter_linux_3.22.1-stable.tar.xz
  mv flutter $HOME/flutter
  echo 'export PATH="$PATH:$HOME/flutter/bin"' >> $HOME/.bashrc
  export PATH="$PATH:$HOME/flutter/bin"
fi

# Install Google Chrome
if ! command -v google-chrome &> /dev/null; then
  echo "Installing Google Chrome..."
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt-get install -y ./google-chrome-stable_current_amd64.deb || sudo apt-get -f install -y
fi

# Install Android SDK Command-line Tools
if [ ! -d "$HOME/android-sdk" ]; then
  echo "Installing Android SDK Command-line Tools..."
  mkdir -p $HOME/android-sdk/cmdline-tools
  wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
  unzip commandlinetools-linux-11076708_latest.zip -d $HOME/android-sdk/cmdline-tools
  mv $HOME/android-sdk/cmdline-tools/cmdline-tools $HOME/android-sdk/cmdline-tools/latest
  echo 'export ANDROID_SDK_ROOT=$HOME/android-sdk' >> $HOME/.bashrc
  echo 'export PATH=$PATH:$HOME/android-sdk/cmdline-tools/latest/bin:$HOME/android-sdk/platform-tools' >> $HOME/.bashrc
  export ANDROID_SDK_ROOT=$HOME/android-sdk
  export PATH=$PATH:$HOME/android-sdk/cmdline-tools/latest/bin:$HOME/android-sdk/platform-tools
fi

# Accept Android SDK licenses and install build tools/platforms
echo "Accepting Android SDK licenses and installing build tools..."
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

echo "Running flutter doctor..."
flutter doctor

echo "Setup complete!"