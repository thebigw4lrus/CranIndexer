require 'open-uri'

module Parser
  class Server
    BATCH_SIZE = 300
    KEY = 'PACKAGES'
    HEAD = 'Package:'
    TAIL = 'NeedsCompilation:'
    
    def initialize(url, limit=nil)
      @url = url
      @limit = limit
      @path = url + KEY
    end

    def start
      file = open(@path)
      scanner = Parser::Scanner.new(file, @url, HEAD, TAIL)
      scanner.scan do |package, scanned|
        batch.fill(package)
        break if limit && scanned >= limit
      end
      batch.flush
    end

    def batch
      @batch ||= Batch.new(BATCH_SIZE)
    end

    def limit
      @limit
    end
  end
end
