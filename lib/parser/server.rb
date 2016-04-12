=begin
  * Name: Parser::Server
  * Description: This class orchestrates the PACKAGES parse process.
  * Input: ::Parser::Server.new(<cran_server>, <limit_of_packages_to_parse>)
  * Author: Javier A. Contreras V.
  * Date: Apr 12, 2016
=end
require 'open-uri'

module Parser
  class Server
    BATCH_SIZE = ::Settings.parser_batch
    KEY = 'PACKAGES'
    HEAD = 'Package:'
    TAIL = 'NeedsCompilation:'

    attr_reader :limit
    
    def initialize(url, limit = nil)
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
  end
end
