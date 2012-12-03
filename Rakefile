require 'hoe'
require './lib/sportdb/play/version.rb'

## NB: plugin (hoe-manifest) not required; just used for future testing/development
Hoe::plugin :manifest   # more options for manifests (in the future; not yet)


Hoe.spec 'sportdb-play' do
  
  self.version = SportDB::Play::VERSION
  
  self.summary = 'sportdb plugin for plays (predictions, betting pool, etc.)'
  self.description = summary

  self.urls    = ['http://geraldb.github.com/sport.db']
  
  self.author  = 'Gerald Bauer'
  self.email   = 'opensport@googlegroups.com'
    

  ## soft deps (dependencies)
  ##   -- sportdb gem must be installed already

  self.licenses = ['Public Domain']

  self.spec_extras = {
    :required_ruby_version => '>= 1.9.2'
  }

end