require 'mongo'
module Db
  class MongoClient
    DBNAME = 'cran_server'
    @@mongo = Mongo::Client.new([ '127.0.0.1:27017' ],
                                :database => DBNAME)
    def initialize(docname)
      @collection = @@mongo[docname]
      @fields = {
        'Date/Publication' => :published,
        'Title' => :title,
        'Description' => :title,
        'Author' => :author,
        'Maintainer' => :mantainer
      }
      @keys = {
        'Package' => :package,
        'Version' => :version
      }
    end

    def insert(packages)
      queries = packages.map {|p| build_query(p.to_hash)}
      if collection.bulk_write(queries, :ordered => true) then
        packages.each(&:sent!) 
      end
    end

    def build_query(info)
      {
        :replace_one => {
          :find => find(info),
          :replacement => replacement(info),
          :upsert => true
        }
      }
    end

    def find(info)
      keys.map {|k, v| {v => info[k]}}.inject(:merge)
    end

    def replacement(info)
      fields.map {|k, v| {v => info[k]}}.inject(:merge)
    end

    def keys
      @keys
    end

    def fields
      @fields
    end

    def collection
      @collection
    end
  end
end
