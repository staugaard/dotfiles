def package_manager
  if RUBY_PLATFORM =~ /linux/
    if !`which dnf`.empty?
      "dnf"
    elsif !`which apt`.empty?
      "apt"
    end
  elsif RUBY_PLATFORM =~ /Darwin/
    "brew"
  end
end
