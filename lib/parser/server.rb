require 'open-uri'
requre 'dcf'

module Parser
  class Server
    BATCH_SIZE = 300
    KEY = 'PACKAGES'
    HEAD = 'Package:'
    TAIL = 'NeedsCompilation:'
    
    def initialize(url)
      @path = url + KEY
    end

    def start
      file = open(@path)

      while line = file.gets
        if line =~ /HEAD/../TAIL/ then
          @package.append(line)
        else
          batch.fill(@package)
          package = []
        end
        batch.send! if batch.full?
      end
      batch.flush!
    end

    def batch
      @batch ||= Batch(BATCH_SIZE)
    end
  end
end
