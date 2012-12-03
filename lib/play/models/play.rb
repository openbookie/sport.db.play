
## NB: just use namespace SportDB::Models (not SportDB::Models::Play)

module SportDB::Models

class Play < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :pool
  
  belongs_to :team1, :class_name => 'Team', :foreign_key => 'team1_id'
  belongs_to :team2, :class_name => 'Team', :foreign_key => 'team2_id'
  belongs_to :team3, :class_name => 'Team', :foreign_key => 'team3_id'
  

  def job_running!
    @job_running = true
  end
  
  def job_done!
    @job_running = false
  end

  def job_running?
    (@job_running ||= false) == true
  end

  def public?
    return true if pool.public?

    # team1, team2 public after kickoff of event
    ## use past?
    Time.now.utc > pool.event.start_at.utc
  end

  
  ## todo/fix: can it be done w/ a has_many macro and a condition?
  def tips
    recs = Tip.where( :pool_id => pool_id, :user_id => user_id ).all
    recs
  end

  ## todo/fix: can it be done w/ a has_many macro and a condition?
  def complete_rankings  # fix rename to points and remove points column from play table??
    recs = Point.where( :pool_id => pool_id, :user_id => user_id ).joins( :round ).order('rounds.pos').all
    recs
  end

  def export?
    # check if user entered some data
    # - do NOT export nil records (all teams blank)
    
    (team1_id.blank? && team2_id.blank? && team3_id.blank?)==false
  end
  
end   # class Play


end  # module SportDB::Models
