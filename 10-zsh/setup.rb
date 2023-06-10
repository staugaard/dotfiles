#!/usr/bin/env ruby

require_relative "../package_manager"

if RUBY_PLATFORM =~ /linux/
  if ENV['SHELL'] !~ /zsh/
    puts "Installing zsh"
    case package_manager
    when "dnf"
      system 'sudo dnf install util-linux-user zsh -y'
    when "apt"
      system 'sudo apt install zsh -y'
    end
    system 'chsh -s $(which zsh)'
  end
end

