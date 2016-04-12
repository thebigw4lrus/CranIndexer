require 'singleton'

module Db
  class Adapter
    include Singleton
    @@size = ::Settings.db_batch
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
      client.insert(@@queue.clone)
      @@queue.reject! {|p| p.sent?}
    end

    def update(package)
      @@queue << package
      process if full?
    end

    def full?
      @@queue.size >= @@size
    end

    def client
      @@client ||= Db::MongoClient.new('packages')
    end

  end
end
