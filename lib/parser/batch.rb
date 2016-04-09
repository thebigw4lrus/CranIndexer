  class Batch
    alias_method :flush!, :send!

    def initialize(size)
      @size = size
      @packages = []
    end
    
    def full?
      len(@packages) > @size
    end

    def send!
      Indexer.process(@packages)
      @package = []
    end

    def fill(package)
      @packages << package
    end
  end
