=begin
  * Name: Parser::Scanner
  * Description: Reads the PACKAGE file, and parse it in a stream fashion way
  * Input: ::Parser::Scanner.new(<io_object>, <cran_server>, <head_package> <tail_package>)
  * Author: Javier A. Contreras V.
  * Date: Apr 12, 2016
=end
require 'dcf'

module Parser
  class Scanner
    class << self
      def parse(content)
        ::Dcf.parse content
      end
    end

    def initialize(file, url, head, tail)
      @url = url
      @scanned = 0
      @file = file
      @head, @tail = head, tail
    end

    def scan
      while line = @file.gets
        if line =~ head .. line =~ tail then
          puts("***** FORMAT #{line} **** ")
          package.add(line)
        else
          @scanned += 1
          package.format!
          yield package, @scanned if block_given?
          package!
        end
      end
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
