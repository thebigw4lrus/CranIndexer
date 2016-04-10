require 'open-uri'

module Parser
  class Server
    BATCH_SIZE = 300
    KEY = 'PACKAGES'
    HEAD = 'Package:'
    TAIL = 'NeedsCompilation:'
    
    def initialize(url)
      @url = url
      @path = url + KEY
    end

    def start
      file = open(@path)
      scanner = Parser::Scanner.new(file, @url, HEAD, TAIL)
      scanner.scan do |package|
        batch.fill(package)
      end
      batch.flush
    end

    def batch
      @batch ||= Batch.new(BATCH_SIZE)
    end
  end
end
