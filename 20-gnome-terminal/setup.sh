#!/bin/bash

platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
  platform='freebsd'
fi

if [[ ! $platform == 'linux' ]]; then
  echo 'Skipping gnome-terminal'
  exit 0
fi

cat ./20-gnome-terminal/gnome-terminal.properties | dconf load /org/gnome/terminal/
