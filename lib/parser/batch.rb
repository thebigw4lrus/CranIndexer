module Parser
  class Batch
    alias_method :flush, :send

    def initialize(size)
      @size = size
    end
    
    def send
      reset! if indexer.process(packages)
    end

    def fill(package)
      packages << package
      send if full?
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
      ::Indexer
    end
  end
end
