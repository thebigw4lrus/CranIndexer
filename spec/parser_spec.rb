require 'spec_helper'

describe Parser  do
  describe Parser::Server do
    it 'fill correctly the batch' do
      batch = double('batch')
      allow(batch).to receive(:flush)
      allow(batch).to receive(:fill)
      allow(batch).to receive(:full?).and_return(false)

      parser = Parser::Server.new("#{Dir.pwd}/spec/support/")
      allow(parser).to receive(:batch).and_return(batch)

      parser.start

      expect(batch).to have_received(:fill).with(kind_of(::Package)).exactly(6).times
      expect(parser).to have_received(:batch).exactly(7).times
    end
  end

  describe Parser::Batch do
    it 'gather packages and send them out correctly' do
      indexer = double('indexer')
      allow(indexer).to receive(:perform).and_return(true)

      batch = Parser::Batch.new(3)
      allow(batch).to receive(:reset!).and_return(true)
      allow(batch).to receive(:indexer).and_return(indexer)

      batch.fill({'Package' => '1'})
      batch.fill({'Package' => '2'})
      
      expect(batch).to_not have_received(:reset!)
      expect(indexer).to_not have_received(:perform)

      batch.fill({'Package' => '3'})

      expect(batch).to have_received(:reset!)
      expect(indexer).to have_received(:perform)
    end
  end
end

