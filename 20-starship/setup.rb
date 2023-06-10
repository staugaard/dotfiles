#!/usr/bin/env ruby

puts "Setting up Starship 🚀"

if RUBY_PLATFORM =~ /linux/
  if `which starship`.empty?
    system 'curl -sS https://starship.rs/install.sh | sh'
  end
else
  system "brew install starship"
  system 'mkdir -p $HOME/.config'
end

system "ln -sf '#{File.expand_path('starship.toml', File.dirname(__FILE__))}' $HOME/.config"
