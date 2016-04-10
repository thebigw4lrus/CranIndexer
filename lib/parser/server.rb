require 'open-uri'
require 'dcf'

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

      while line = file.gets
        if line =~ head .. line =~ tail then
          package.concat(format(line))
        else
          # Think in replace this inject to smth
          # more readable
          package << {'url' => @url}
          batch.fill(package.inject(:merge))
          reset_package!
        end
      end
      batch.flush
    end

    def batch
      @batch ||= Batch.new(BATCH_SIZE)
    end

    def package
      @package ||= []
    end

    def reset_package!
      @package = []
    end

    def format(line)
      ::Dcf.parse line
    end

    def head
      /#{HEAD}/
    end

    def tail
      /#{TAIL}/
    end
  end
end
