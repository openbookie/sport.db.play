
## NB: just use namespace SportDb::Model (not SportDb::Model::Play)

module SportDb
  module Model


class BonusTip < ActiveRecord::Base
  
  self.table_name = 'bonus_tips'

  belongs_to :user

end # class BonusTip


  end  # module Model
end  # module SportDb

