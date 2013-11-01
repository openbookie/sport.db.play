
## NB: just use namespace SportDb::Models (not SportDb::Models::Play)

module SportDb::Models


class BonusQuestion < ActiveRecord::Base
  
  self.table_name = 'bonus_questions'

  has_many :tips, :class_name => 'BonusTip', :foreign_key => 'question_id'

end # class BonusQuestion


end  # module SportDb::Models
