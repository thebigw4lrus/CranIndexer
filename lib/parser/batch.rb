=begin
  * Name: Parser::Batch
  * Description: Represents a single batch of the PACKAGE file
  * Input: ::Parser::Batch.new(<size_of_the_batch>)
  * Author: Javier A. Contreras V.
  * Date: Apr 12, 2016
=end
module Parser
  class Batch
    def initialize(size)
      @size = size
    end
    
    def process
      reset! if indexer.perform(packages)
    end
    alias :flush :process

    def fill(package)
      packages << package
      process if full?
    end

    def full?
      packages.size >= @size
    end

    def packages
      @packages ||= []
    end

    def reset!
      @packages = []
    end

    def indexer
      ::Indexer::Packages
    end
  end
end
