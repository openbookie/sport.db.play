
## NB: just use namespace SportDb::Models (not SportDb::Models::Play)

module SportDb::Models


class BonusTip < ActiveRecord::Base
  
  self.table_name = 'bonus_tips'

  belongs_to :user

end # class BonusTip


end  # module SportDb::Models

