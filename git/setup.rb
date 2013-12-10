#!/usr/bin/env ruby

require 'erb'

def get_value(key, title)
  value = `git config --get #{key}`.strip

  return value if $?.exitstatus == 0

  print(title + ': ')
  STDOUT.flush

  STDIN.gets.chomp
end

template_filename = File.expand_path('gitconfig.erb', File.dirname(__FILE__))
template = File.read(template_filename)
contents = ERB.new(template).result(binding)

target_filename = File.expand_path('.gitconfig', ENV['HOME'])

puts "Writing #{target_filename}"
File.open(target_filename, 'w') do |target|
  target.write(contents)
end
