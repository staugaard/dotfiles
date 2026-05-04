#!/usr/bin/env ruby

require_relative "../package_manager"

puts "installing micro"
if RUBY_PLATFORM =~ /linux/
  system "sudo #{package_manager} install micro -y"
else
  system 'brew install micro'
end
