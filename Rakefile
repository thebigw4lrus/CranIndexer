require "rspec/core/rake_task"
require 'rufus-scheduler'

def start_parser
  Dir["#{Dir.pwd}/lib/settings/*.rb"].each { |f| load(f) }
  Dir["#{Dir.pwd}/lib/**/*.rb"].each { |f| load(f) }
  Parser::Server.new(::Settings.server, ::Settings.limit).start
end

def schedule_parser
    scheduler = Rufus::Scheduler.new
    scheduler.schedule '00:00' do
      start_parser
    end
    scheduler.join
end

# Test tasks
namespace :spec do
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = Dir['spec/*_spec.rb']
  end
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = Dir['spec/integration/*_spec.rb']
  end
end

# Run task
namespace :run do
  # Execute the indexer
  task :now do
    start_parser
  end
  # Schedule the indexer
  task :schedule do
    schedule_parser
  end
  # Start the webserver
  task :server do
    ruby "app/server.rb"
  end
end





