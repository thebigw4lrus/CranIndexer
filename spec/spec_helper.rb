Dir["#{Dir.pwd}/lib/settings/*.rb"].each { |f| load(f) }
Dir["#{Dir.pwd}/lib/**/*.rb"].each { |f| load(f) }
