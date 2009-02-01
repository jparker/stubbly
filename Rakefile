desc 'Restart app server'
task :restart do
  system "touch #{File.join(File.dirname(__FILE__), 'tmp', 'restart.txt')}"
end

desc 'Start irb with necessary libraries'
task :console do
  ENV['RACK_ENV'] ||= 'development'
  exec 'irb', '-rstubble'
end

desc 'Setup database'
task :database do
  ENV['RACK_ENV'] ||= 'development'
  require 'stubble'
  DataMapper.auto_migrate!
end
