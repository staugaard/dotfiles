#!/usr/bin/env sh

echo 'Setting Dock Preferences'
defaults write com.apple.dock no-glass -boolean YES
defaults write com.apple.dock orientation right
killall Dock
