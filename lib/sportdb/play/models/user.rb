# encoding: utf-8


## NB: just use namespace SportDb::Model (not SportDb::Model::Play)

module SportDb
  module Model


class User < ActiveRecord::Base
  
  has_many :pools
  has_many :tips
  has_many :plays


end  # class User

  end # module Model
end  # module SportDb
