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
