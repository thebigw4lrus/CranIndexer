require 'spec_helper'

describe Package  do
  it 'should build the urls package correctly' do
    package = ::Package.new('https://someserver/src/contrib/')
    package.add([{'Package' => 'mypack'}, {'Version' => '1.0'}])

    expected_url = 'https://someserver/src/contrib/mypack_1.0.tar.gz'
    expect(package.url).to eq(expected_url)
  end

  it 'should adds the package-specific info correctly' do
      url = "#{Dir.pwd}/spec/support/"
      package = ::Package.new(url)
      expect(package.to_hash).to eq({'url' => url})

      package.add([{'Package' => 'abbyyR'},
                   {'Version' => '0.3'}])
      expect(package.to_hash['LazyData']).to eq(nil)
      package.enrich

      expect(package.to_hash['LazyData']).to eq("true")
  end
end
