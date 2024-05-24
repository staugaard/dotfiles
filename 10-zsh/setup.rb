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

  puts "Installing zsh tools"
  case package_manager
  when "dnf"
    system 'sudo dnf install zsh-syntax-highlighting -y'
  when "apt"
    system 'sudo apt install zsh-syntax-highlighting -y'
  end
elsif RUBY_PLATFORM =~ /Darwin/
  system "brew install zsh-syntax-highlighting"
end

system "cargo install eza"
system "cargo install zoxide --locked"

system "mkdir -p $HOME/.zsh"
system "ln -sf '#{File.expand_path('zendesk.zsh', File.dirname(__FILE__))}' $HOME/.zsh"
