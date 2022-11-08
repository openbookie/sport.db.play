
## NB: just use namespace SportDb::Model (not SportDb::Model::Play)

module SportDb
  module Model

class BonusRound < ActiveRecord::Base
  
  self.table_name = 'bonus_rounds'
  
  has_many :questions,  order: 'pos', class_name: 'BonusQuestion', foreign_key: 'round_id'
  belongs_to :pool

end # class BonusRound

  end # module Model
end  # module SportDb
