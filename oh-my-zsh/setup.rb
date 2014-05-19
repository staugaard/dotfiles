#!/usr/bin/env ruby

require 'pathname'

oh_my_zsh_path = Pathname.new(ENV['HOME']) + '.oh-my-zsh'

if File.exist?(oh_my_zsh_path)
  system "/usr/bin/env ZSH=#{oh_my_zsh_path} /bin/sh #{oh_my_zsh_path}/tools/upgrade.sh"
else
  puts "Installing oh-my-zsh"
  system "git clone https://github.com/robbyrussell/oh-my-zsh.git '#{oh_my_zsh_path}'"
  system "echo $SHELL | grep 'zsh' || chsh -s `which zsh`"
end

source_custom_path = Pathname.new(File.dirname(__FILE__)) + 'custom'

(source_custom_path + 'plugins').children.each do |plugin|
  puts "Symlinking the #{plugin.basename} plugin"
  system "ln -sf #{plugin.realpath} #{oh_my_zsh_path + 'custom' + 'plugins'}"
end

puts "Symlinking theme"
system "ln -sf #{(source_custom_path + 'staugaard.zsh-theme').realpath} #{oh_my_zsh_path + 'custom'}"
