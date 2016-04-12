require 'spec_helper'

describe Db  do
  describe Db::Adapter do
    it 'respond accordingly to observer pattern' do
      ::Db::Adapter.size = 3
      db_adapter = ::Db::Adapter.instance
      allow(db_adapter).to receive(:update)

      url = "#{Dir.pwd}/spec/support/"
      basic_info = "Package: abbyyR\nVersion: 0.3\n" 

      package1 = ::Package.new(url)
      package1.add(basic_info)
      package1.format!
      package2= ::Package.new(url)
      package2.add(basic_info)
      package2.format!

      expect(db_adapter).to_not have_received(:update)

      package1.enrich
      expect(db_adapter).to have_received(:update).once
      package2.enrich
      expect(db_adapter).to have_received(:update).twice
    end
  end
end
