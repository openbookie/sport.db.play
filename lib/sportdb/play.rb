## NB: do NOT require sportdb (avoid circular loading)
#### require 'sportdb'


require 'sportdb/play/version'

require 'sportdb/play/schema'
require 'sportdb/play/models/bonus_point'
require 'sportdb/play/models/bonus_question'
require 'sportdb/play/models/bonus_round'
require 'sportdb/play/models/bonus_tip'
require 'sportdb/play/models/game'
require 'sportdb/play/models/play'
require 'sportdb/play/models/point'
require 'sportdb/play/models/pool'
require 'sportdb/play/models/tip'
require 'sportdb/play/models/user'


module SportDb::Play

  def self.banner
    "sportdb-play/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  ##  cut off folders lib(#1)/sportdb(#2) to get to root
  def self.root
    "#{File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )}"
  end
  
  def self.create
    CreateDb.new.up
    WorldDb::Models::Prop.create!( key: 'db.schema.sport.play.version', value: VERSION )
  end

end  # module SportDb::Play


## say hello
puts SportDb::Play.banner    if $DEBUG
