
## NB: just use namespace SportDb::Models (not SportDb::Models::Play)

module SportDb::Models

class BonusRound < ActiveRecord::Base
  
  self.table_name = 'bonus_rounds'
  
  has_many :questions,  :order => 'pos', :class_name => 'BonusQuestion', :foreign_key => 'round_id'
  belongs_to :pool

end # class BonusRound

end  # module SportDb::Models
