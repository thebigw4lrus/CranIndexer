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

      expect(batch).to have_received(:fill).exactly(6).times
      expect(parser).to have_received(:batch).exactly(7).times
      expect(batch).to have_received(:fill).with(hash_including('Package' => 'abc'))
    end
  end

  describe Parser::Batch do
    it 'gather packages and send them out correctly' do
      indexer = double('indexer')
      allow(indexer).to receive(:process).and_return(true)

      batch = Parser::Batch.new(3)
      allow(batch).to receive(:send).and_return(true)
      allow(batch).to receive(:reset!).and_return(true)
      allow(batch).to receive(:indexer).and_return(true)

      expected_batch = [{'Package' => '1'},
                        {'Package' => '2'},
                        {'Package' => '3'}]

      batch.fill expected_batch[0]
      batch.fill expected_batch[1]
      
      expect(batch).to_not have_received(:send)
      expect(batch).to_not have_received(:reset!)

      batch.fill expected_batch[2]

      expect(batch).to have_received(:send)
      #expect(batch).to have_received(:reset!)
      #expect(indexer).to have_received(:process).with(expected_batch)
    end
  end
end

