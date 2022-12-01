
## NB: do NOT require sportdb (avoid circular loading)
#### require 'sportdb'

require 'sportdb/market/version'

require 'sportdb/market/schema'
require 'sportdb/market/models/service'
require 'sportdb/market/models/group_quote'
require 'sportdb/market/models/event_quote'
require 'sportdb/market/models/quote'
require 'sportdb/market/models/game'
require 'sportdb/market/loader'
require 'sportdb/market/reader'


module SportDb
  module Market

  def self.banner
    "sportdb-market #{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  ##  cut off folders lib(#1)/sportdb(#2) to get to root
  def self.root
    "#{File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )}"
  end
  
  ## builtin path to fixture data
  def self.data_path
    "#{root}/data"
  end
  
  def self.create
    CreateDb.new.up
    # WorldDb::Model::Prop.create!( key: 'db.schema.sport.market.version', value: SportDb::Market::VERSION )
  end


  def self.read_setup( setup, include_path )
    reader = Reader.new( include_path )
    reader.load_setup( setup )
  end

  def self.read_all( include_path )   # convenience helper
    read_setup( 'setups/all', include_path )
  end


  class Deleter
    ## todo: move into its own file???    
    
    ## make models available in sportdb module by default with namespace
    #  e.g. lets you use Team instead of Model::Team 
    include SportDb::Models

    def run( args=[] )
      # for now delete all tables

      Service.delete_all
      Quote.delete_all
      GroupQuote.delete_all
      EventQuote.delete_all
    end
    
  end
  
  # delete ALL records (use with care!)
  def self.delete!
    puts '*** deleting sport market table records/data...'
    Deleter.new.run
  end # method delete!

  end # module Market
end  # module SportDb


## say hello
puts SportDb::Market.banner
