
# NB: just use namespace SportDb::Model (not SportDb::Model::Market)

module SportDb
  module Model

################################
# extend Game w/ quotes etc.

class Game
  
  has_many   :quotes
   
end  # class Game

  end # module Model
end  # module SportDb
