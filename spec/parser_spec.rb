require 'spec_helper'

describe Parser::Server  do

  it 'fill correctly the batch' do
    batch = double('batch')
    allow(batch).to receive(:send)
    allow(batch).to receive(:flush)
    allow(batch).to receive(:fill)
    allow(batch).to receive(:full?).and_return(false)

    parser = Parser::Server.new("#{Dir.pwd}/spec/support/")
    allow(parser).to receive(:batch).and_return(batch)

    parser.start

    expect(batch).to have_received(:fill).exactly(6).times
    expect(batch).to have_received(:fill).with(array_including({'Package' => 'abc'}))
  end
  
end

