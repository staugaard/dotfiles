#!/usr/bin/env ruby

unless File.exist?('/Applications/Sublime Text.app')
  puts "Installing Sublime Text 3"
  system 'hdiutil mount https://download.sublimetext.com/Sublime%20Text%20Build%203126.dmg'
  system 'cp -r /Volumes/Sublime\ Text/Sublime\ Text.app /Applications'
  system 'hdiutil unmount /Volumes/Sublime\ Text'
end

puts "Symlinking #{ENV['HOME']}/bin/subl"
system 'mkdir -p $HOME/bin'
system 'ln -sf "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" $HOME/bin/subl'

sublime_support_path = "#{ENV['HOME']}/Library/Application Support/Sublime Text 3"
system "mkdir -p '#{sublime_support_path}'"

#http://stackoverflow.com/questions/19529999/add-package-control-in-sublime-text-3-through-the-command-line
unless File.exist?("#{sublime_support_path}/Installed Packages/Package Control.sublime-package")
  puts "Installing Sublime Text Package Controll"
  system "wget --quiet --directory-prefix='#{sublime_support_path}/Installed Packages' https://sublime.wbond.net/Package%20Control.sublime-package"
end

puts "Symlinking Sublime Text Settings"
system "mkdir -p '#{sublime_support_path}/Packages/User'"
['Staugaard.tmTheme', 'Preferences.sublime-settings', 'Package Control.sublime-settings'].each do |file|
  system "ln -sf '#{File.expand_path(file, File.dirname(__FILE__))}' '#{sublime_support_path}/Packages/User'"
end

