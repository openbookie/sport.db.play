# encoding: utf-8


## NB: just use namespace SportDb::Models (not SportDb::Models::Play)

module SportDb::Models


class User < ActiveRecord::Base
  
  has_many :pools
  has_many :tips
  has_many :plays


end  # class User

end  # module SportDb::Models
