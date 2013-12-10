#!/usr/bin/env ruby

require 'pathname'

oh_my_zsh_path = Pathname.new(ENV['HOME']) + '.oh-my-zsh'

if !File.exist?(oh_my_zsh_path)
  puts "installing oh-my-zsh"
  system "git clone https://github.com/robbyrussell/oh-my-zsh.git '#{oh_my_zsh_path}'"
end

source_custom_path = Pathname.new(File.dirname(__FILE__)) + 'custom'
source_custom_path.children.each do |custom|
  puts "Symlinking #{oh_my_zsh_path + custom.relative_path_from(source_custom_path.parent)}"
  system "ln -sf #{custom.realpath} #{oh_my_zsh_path + 'custom'}"
end
