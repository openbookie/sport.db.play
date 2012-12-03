# encoding: utf-8

## NB: just use namespace SportDB::Models (not SportDB::Models::Play)

module SportDB::Models


class Pool < ActiveRecord::Base
  
  belongs_to :user   # is owner/admin/manager  
  
  has_many :bonus_rounds
  
  has_many :plays   # pools_users join table
    
  ## rename to users from players??
  has_many :players, :through => :plays, :source => :user

  belongs_to :event
  
    
  def full_title
    ####    "#{title} #{event.title}#{fix? ? ' Fix' : ''}"
    "#{title} #{event.title}"
  end


  def team3?    # tip for 3rd place?
    event.team3 == true
  end
  
end   # class Pool


end  # module SportDB::Models

