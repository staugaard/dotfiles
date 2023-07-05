#!/bin/bash

if ! which nvm &>/dev/null; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  git checkout .zshrc
fi
