#!/usr/bin/env ruby

if RUBY_PLATFORM =~ /linux/
  if `which go`.empty?
    puts "Installing Go"
    system 'wget https://go.dev/dl/go1.20.6.linux-amd64.tar.gz'
    system 'sudo tar -C /usr/local -xzf go1.20.6.linux-amd64.tar.gz'
    system 'rm go1.20.6.linux-amd64.tar.gz'
  end
else
  puts "Installing Go"
  system 'brew install go'
end
