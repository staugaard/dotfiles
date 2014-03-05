#!/usr/bin/env ruby

packages = [
  'jshint',
  'sort-lines',
  'asteroids',
  'tomorrow-night-eighties-syntax',
  'toggle-quotes'
]

unless File.exist?('/Applications/Atom.app')
  puts "Atom is not installed"
  exit
end

puts "Installing Atom packages"
packages.each do |package|
  system "apm list | grep ' #{package}@' > /dev/null || (echo \"  #{package}\" && apm install #{package})"
end
