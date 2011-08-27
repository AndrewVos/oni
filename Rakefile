require 'bundler/gem_tasks'

task :default => [:spec, :feature]

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:feature)

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = "--color"
end
