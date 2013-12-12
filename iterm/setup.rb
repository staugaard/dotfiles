#!/usr/bin/env ruby

system 'defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/.iterm"'
system 'defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true'
