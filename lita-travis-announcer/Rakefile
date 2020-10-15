require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :send_posts do
  puts 'Running postman test suite with newman...'
  `newman run ./spec/postman/*`
  puts 'Done.'
end
