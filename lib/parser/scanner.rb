require 'dcf'

module Parser
  class Scanner
    def initialize(file, url, head, tail)
      @url = url
      @file = file
      @head, @tail = head, tail
    end

    def scan
      while line = @file.gets
        if line =~ head .. line =~ tail then
          package.add(format(line))
        else
          yield(package) if block_given?
          package!
        end
      end
    end

    def format(line)
      ::Dcf.parse line
    end

    def package
      @package ||= package!
    end

    def package!
      @package = ::Package.new(@url)
    end

    def head
      /#{@head}/
    end

    def tail
      /#{@tail}/
    end
  end
end
