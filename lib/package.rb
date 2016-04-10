require 'rubygems/package'
require 'zlib'

class Package
  def initialize(url)
    @info = {'url' => url}
  end

  def add(value)
    @info.update(value.inject(:merge))
  end

  def enrich
    begin
      description = Parser::Scanner.parse(unpack)
      @info.update(description.inject(:merge))
    rescue Gem::Package::TarInvalidError => e
      # log object would be better
      puts "Tar corrupted #{e}"
    rescue OpenURI::HTTPError => e
      puts "Uri not found #{e}"
    end
  end

  def unpack
      source = open(url)
      gz = Zlib::GzipReader.new(source)
      tar = Gem::Package::TarReader.new(gz)

      description = tar.detect do |d|
        d.full_name.include?('DESCRIPTION')
      end.read
  end

  def url
    [@info['url'],
     @info['Package'], '_',
     @info['Version'], '.tar.gz'].join
  end

  def to_hash
    @info
  end
end