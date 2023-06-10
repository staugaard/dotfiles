#!/usr/bin/env ruby

require_relative "../package_manager"

puts "installing micro"
if RUBY_PLATFORM =~ /linux/
  system "sudo #{package_manager} install micro -y"
else
  system 'brew install micro'
end

puts "Symlinking micro configuration"
system 'mkdir -p $HOME/.config/micro'
system "ln -sf '#{File.expand_path('settings.json', File.dirname(__FILE__))}' $HOME/.config/micro"
