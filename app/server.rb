require 'sinatra'
require 'rubygems'
require 'mongo'
require 'json/ext'
require 'yaml'

configure do
  name = YAML.load_file("#{Dir.pwd}/config/settings.yml")['db']
  db = Mongo::Client.new(['127.0.0.1:27017'], database: name)
  set :mongo_db, db[:packages]
end

get '/' do
  content_type :json
  settings.mongo_db.find.to_a.to_json
end
