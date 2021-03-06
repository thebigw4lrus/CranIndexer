=begin
  * Name: Db::MongoClient
  * Description: Takes care of build the queries and insert records onto the Db
  * Input: Db::MongoClient.new(<document_name>)
  * Author: Javier A. Contreras V.
  * Date: Apr 12, 2016
=end
require 'mongo'
module Db
  class MongoClient
    DBNAME = ::Settings.db
    @@mongo = Mongo::Client.new(['127.0.0.1:27017'], database: DBNAME)

    attr_reader :keys, :fields, :collection

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
      queries = packages.map { |p| build_query(p.to_hash) }
      packages.each(&:sent!) if collection.bulk_write(queries, ordered: true)
    end

    def build_query(info)
      {
        replace_one: {
          find: find(info),
          replacement: replacement(info),
          upsert: true
        }
      }
    end

    def find(info)
      keys.map { |k, v| { v => info[k] } }.inject(:merge)
    end

    def replacement(info)
      fields.map { |k, v| { v => info[k] } }.inject(:merge)
    end
  end
end
