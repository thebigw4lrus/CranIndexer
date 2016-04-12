require 'rubygems/package'
require 'observer'
require 'zlib'

class Package
  include Observable

  def initialize(url)
    @info = {'url' => url}
    @sent = false
    @raw_info = ""
    add_observer(::Db::Adapter.instance)
  end

  def add(value)
    @raw_info << value
  end

  def format!
    @info.update(::Parser::Scanner.parse(@raw_info)[0])
  end

  def enrich
    begin
      description = Parser::Scanner.parse(unpack)
      @info.update(description.inject(:merge))
      changed
      notify_observers(self)
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

  def sent!
    @sent = true
  end

  def sent?
    @sent
  end

  def to_hash
    @info
  end
end
