require "bundler/gem_tasks"

task :default => :spec

task :spec do
  system 'bundle exec rspec spec'
end

task :clean do
  system 'rm *.gem'
  system 'rm -fr pkg'
end

task :build => :clean do
  system 'gem build humble.gemspec'
end

task :publish => :build do
  system 'gem push *.gem'
end
