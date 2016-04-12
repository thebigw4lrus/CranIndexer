=begin
  * Name: Settings
  * Description: Keep all the settings in memory as a singleton class
  * Author: Javier A. Contreras V.
  * Date: Apr 12, 2016
=end
require 'yaml'

module Settings
  extend self
  @config = ::YAML.load_file("#{Dir.pwd}/config/settings.yml")

  def server
    @config['server']
  end

  def parser_batch
    @config['parser_batch']
  end

  def db_batch
    @config['db_batch']
  end

  def db
    @config['db']
  end

  def limit
    @config['limit']
  end
end
