=begin
  * Name: Indexer::Packages
  * Description: Start the indexers as threads per batch
  * Input: ::Indexer::Packages.new(<array_of_packages_object>)
  * Author: Javier A. Contreras V.
  * Date: Apr 12, 2016
=end
module Indexer
  class Packages
    class << self
      def perform(packages)
        self.new(packages).start
      end
    end

    def initialize(packages)
      @packages = packages
    end

    def start
      @packages.each do |pck|
        threads << ::Thread.new(pck) {|pck| pck.enrich}
        threads.each {|thr| thr.join}
      end
    end

    def threads
      @treads ||= []
    end
  end
end
