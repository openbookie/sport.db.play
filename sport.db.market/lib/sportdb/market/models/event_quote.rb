
# NB: just use namespace SportDb::Model (not SportDb::Model::Market)

module SportDb
  module Model

class EventQuote < ActiveRecord::Base
  
  self.table_name = 'event_quotes'
  
  belongs_to :service
  belongs_to :event
  belongs_to :team

  def self.create_from_ary!( teams_with_odds, service, event )
    teams_with_odds.each do |values|
      EventQuote.create!(
        :service => service,
        :event   => event,
        :team    => values[0],
        :odds    => values[1] )
    end # each team
  end


end  # class EventQuote

  end # module Model
end  # module SportDb
