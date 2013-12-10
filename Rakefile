desc "install the dot files into user's home directory"
task :install => [:install_symlinks, :install_executables] do
end

task :install_symlinks do
  `git ls-files '.*'`.strip.split.each do |dotfile|
    source_filename = File.expand_path(dotfile, File.dirname(__FILE__))
    target_filename = File.expand_path(dotfile, ENV['HOME'])
    puts "Linking #{target_filename}"
    `ln -sf #{source_filename} #{target_filename}`
  end
end

task :install_executables do
  `find . -perm +111 -type f -depth 2`.strip.split.each do |executable|
    # puts "Running #{executable}"
    system(executable)    
  end
end

task :default => :install
