require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'dotenv/tasks'

# Default directory to look in is `/specs`
# Run with `rake spec`
desc "Run RSpec tests (use rake spec SPEC_OPTS='...' to pass rspec options)"
RSpec::Core::RakeTask.new(:spec)

desc "Run RSpec tests in Travis CI environment"
RSpec::Core::RakeTask.new(:travis) do |t|
  t.rspec_opts = '--tag ~live_aws' # skip the tests that require connection to unstubbed live AWS
end

task :default => :spec

