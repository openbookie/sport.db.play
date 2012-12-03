## NB: do NOT require sportdb (avoid circular loading)
#### require 'sportdb'


require 'sportdb/play/version'

require 'sportdb/play/schema'
require 'sportdb/play/models/play'


module SportDB::Play

  def self.banner
    "sportdb-play #{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  ##  cut off folders lib(#1)/sportdb(#2) to get to root
  def self.root
    "#{File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )}"
  end
  
  def self.create
    CreateDB.up
  end

end  # module SportDB::Play


## say hello
puts SportDB::Play.banner
