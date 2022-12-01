
# NB: just use namespace SportDb::Model (not SportDb::Model::Market)

module SportDb
  module Model

class Service < ActiveRecord::Base
    
   has_many :event_quotes, :order => 'odds'   # event_(team_winner)_quotes
   has_many :group_quotes, :order => 'odds'   # group_(team_winner)_quotes
   
end  # class Service

  end  # module Model
end  # module SportDb
