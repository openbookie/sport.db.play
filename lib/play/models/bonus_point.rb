
## NB: just use namespace SportDB::Models (not SportDB::Models::Market)

module SportDB::Models


class BonusPoint < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :pool
  belongs_to :round, :class_name => 'BonusRound', :foreign_key => 'round_id'
  
end  # class BonusPoint



end  # module SportDB::Models