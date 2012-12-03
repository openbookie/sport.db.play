# encoding: utf-8


## NB: just use namespace SportDB::Models (not SportDB::Models::Play)

module SportDB::Models


class User < ActiveRecord::Base
  
  has_many :pools
  has_many :tips
  has_many :plays


end  # class User

end  # module SportDB::Models
