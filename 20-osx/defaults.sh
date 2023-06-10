#!/bin/bash

platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
  platform='freebsd'
fi

if [[ $platform == 'linux' ]]; then
  echo 'Skipping osx'
  exit 0
fi


# lots of good inspiration here:
# https://github.com/mathiasbynens/dotfiles/blob/master/.macos

echo "Setting TouchPad Preferences"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "Setting Keyboard Preferences"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo 'Setting Dock Preferences'
defaults write com.apple.dock no-glass -boolean YES
defaults write com.apple.dock orientation right
defaults write com.apple.dock tilesize -int 46

killall Dock
killall SystemUIServer
