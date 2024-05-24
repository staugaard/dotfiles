#!/bin/bash

platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
  platform='freebsd'
fi

if [[ $platform == 'linux' ]]; then
  sudo dnf -y install make
  wget https://github.com/postmodern/ruby-install/releases/download/v0.9.0/ruby-install-0.9.0.tar.gz
  tar -xzvf ruby-install-0.9.0.tar.gz
  cd ruby-install-0.9.0/
  sudo make install
  cd ..
  rm -rf ruby-install*

  wget https://github.com/postmodern/chruby/releases/download/v0.3.9/chruby-0.3.9.tar.gz
  tar -xzvf chruby-0.3.9.tar.gz
  cd chruby-0.3.9/
  sudo make install
  cd ..
  rm -rf chruby*
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
else
  brew install ruby-install chruby
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  source /usr/local/opt/chruby/share/chruby/auto.sh
fi

ruby-install --no-reinstall 3
chruby 3
rake
