require 'spec_helper'
require 'mongo'
SERVER = ::Settings.server
DB = ::Settings.db
describe "End-to-End" do
  it 'runs end to end' do
    client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => DB)
    client.database.drop
    db = client['packages']

    parser = Parser::Server.new(SERVER, 50)
    parser.start

    expect(db.find.to_a.size).to eq(50)
  end
end
