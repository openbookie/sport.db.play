
## NB: just use namespace SportDB::Models (not SportDB::Models::Play)

module SportDB::Models


class BonusTip < ActiveRecord::Base
  
  self.table_name = 'bonus_tips'

  belongs_to :user

end # class BonusTip


end  # module SportDB::Models