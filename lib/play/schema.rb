module SportDB::Play

class CreateDB

## make models available in sportdb module by default with namespace
#  e.g. lets you use Team instead of Models::Team 
  include SportDB::Models


  def self.up
  
    ActiveRecord::Schema.define do

change_table :games do |t|
  t.boolean    :locked, :null => false, :default => false
end

#####################################
## new tables / create tables
####################################

create_table :users do |t|
  t.string  :key,             :null => false   # import/export key
  t.timestamps
end

add_index :users, :key,   :unique => true 


create_table :pools do |t|
  t.references  :event,  :null => false
  t.string      :title,  :null => false
  t.references  :user,   :null => false  # owner/manager/admin of pool
  t.boolean     :public, :null => false, :default => true   # make all tips public (not private/secret)
  t.boolean     :locked, :null => false, :default => false
  t.string      :key   # import/export key
  t.timestamps
end

add_index :pools, :key,   :unique => true 
add_index :pools, :event_id
add_index :pools, :user_id


create_table :plays do |t|
  t.references :user, :null => false
  t.references :pool, :null => false
  t.references :team1   # winner (1st)
  t.references :team2   # runnerup (2nd)
  t.references :team3   # 2n runnerup (3nd)

  t.integer    :total_pts, :null => false, :default => 0   # cached total player points 
  t.integer    :total_pos, :null => false, :default => 0   # cached total ranking/position 

  t.timestamps
end

add_index :plays, [:user_id,:pool_id], :unique => true  # enforce only one play per user and pool
add_index :plays, :user_id
add_index :plays, :pool_id


create_table :tips do |t|
  t.references :user, :null => false
  t.references :pool, :null => false
  t.references :game, :null => false
  t.integer    :score1
  t.integer    :score2
  t.integer    :score3    # verlaengerung (opt)
  t.integer    :score4
  t.integer    :score5    # elfmeter (opt)
  t.integer    :score6
  t.string     :toto12x      # 1,2,X,nil  calculate on save

  t.timestamps
end

add_index :tips, [:user_id,:pool_id,:game_id], :unique => true 
add_index :tips, :user_id
add_index :tips, :pool_id
add_index :tips, :game_id



create_table :points do |t|
  t.references :user,  :null => false
  t.references :pool,  :null => false
  t.references :round, :null => false
  
  t.integer    :round_pts, :null => false, :default => 0   # points for this round
  t.integer    :round_pos, :null => false, :default => 0   # ranking/position for this round

  t.integer    :total_pts, :null => false, :default => 0   # total points up to(*) this round (including)  (* rounds sorted by pos)
  t.integer    :total_pos, :null => false, :default => 0   # ranking/position for points up to this round

  t.integer    :diff_total_pos, :null => false, :default => 0
  
  t.timestamps
end

add_index :points, [:user_id,:pool_id,:round_id], :unique => true 



create_table :bonus_rounds do |t|
  t.references :pool,   :null => false
  t.string     :title,  :null => false
  t.integer    :pos,     :null => false
  t.timestamps
end

create_table :bonus_questions do |t|
  t.references :round,  :null => false
  t.string     :title,  :null => false
  t.integer    :pos,    :null => false
  t.timestamps
end
    
create_table :bonus_answers do |t|
  # to be done
  t.timestamps
end
    
create_table :bonus_tips do |t|
  t.references :user,     :null => false
  t.references :question, :null => false
  t.integer    :pts     , :null => false, :default => 0
  t.timestamps
end

create_table :bonus_points do |t|
  t.references :user,  :null => false
  t.references :pool,  :null => false  ## todo: check if we keep reference to pool (because round_id depends itself on pool)
  t.references :round, :null => false   # nb: is bonus_round_id
  
  t.integer    :round_pts, :null => false, :default => 0   # points for this round
  t.integer    :round_pos, :null => false, :default => 0   # ranking/position for this round

  t.integer    :total_pts, :null => false, :default => 0   # total points up to(*) this round (including)  (* rounds sorted by pos)
  t.integer    :total_pos, :null => false, :default => 0   # ranking/position for points up to this round

  t.integer    :diff_total_pos, :null => false, :default => 0
  
  t.timestamps
end

add_index :bonus_points, [:user_id,:pool_id,:round_id], :unique => true

    end # block Schema.define

    Prop.create!( key: 'db.schema.sport.play.version', value: SportDB::Play::VERSION )

  end # method self.up

end # class CreateDB


end # module SportDB::Play
