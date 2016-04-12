module Parser
  class Batch
    def initialize(size)
      @size = size
    end
    
    def process
      reset! if indexer.perform(packages)
    end
    alias_method :flush, :process

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
