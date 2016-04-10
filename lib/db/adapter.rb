module Db
  class Adapter
    @@size = 10
    @@queue = []

    class << self
      def queue
        @@queue
      end

      def size=(size)
        @@size = size
      end
    end

    def process
      # Here will be the Db store logic
      # It will be async and batch-fashioned
      @@queue
    end

    def update(info)
      @@queue << info
      process if full?
    end

    def full?
      @@queue.size >= @@size
    end

    def queue
      self.class.queue
    end
  end
end
