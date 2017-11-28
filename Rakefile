require "bundler/gem_tasks"

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
begin
  load 'rails/tasks/engine.rake'
rescue LoadError
  puts 'Could not load rails/tasks/engine.rake'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')
# task default: :spec
task default: 'matrix:spec'
