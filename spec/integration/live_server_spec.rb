require 'spec_helper'
require 'mongo'
SERVER = 'https://cran.r-project.org/src/contrib/'
describe "End-to-End" do
  it 'runs end to end' do
    client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => "cran_server")
    client.database.drop
    db = client['packages']

    parser = Parser::Server.new(SERVER, 50)
    parser.start

    expect(db.find.to_a.size).to eq(49)
  end
end
