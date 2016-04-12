require "rspec/core/rake_task"

namespace :spec do
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = Dir['spec/*_spec.rb']
  end
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = Dir['spec/integration/*_spec.rb']
  end
end
