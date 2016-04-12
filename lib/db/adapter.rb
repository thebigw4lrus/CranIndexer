=begin
  * Name: Db::Adapter
  * Description: Handle the adaptation between the backend and the DB
  * Author: Javier A. Contreras V.
  * Date: Apr 12, 2016
=end
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
      @@queue.reject! { |p| p.sent? }
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
