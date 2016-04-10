require 'spec_helper'

describe Indexer do
  describe Indexer::Packages do
    it 'trigger succesfully the enrich info process' do
      db_adapter = ::Db::Adapter.new
      package1 = ::Package.new('url1', db_adapter)
      package2 = ::Package.new('url2', db_adapter)
      allow(package1).to receive(:enrich).and_return(true)
      allow(package2).to receive(:enrich).and_return(true)

      Indexer::Packages.perform([package1, package2])

      expect(package1).to have_received(:enrich)
      expect(package2).to have_received(:enrich)
    end
  end
end

