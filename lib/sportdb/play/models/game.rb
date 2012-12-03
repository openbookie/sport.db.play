


module SportDB::Models


### NB: extend Game model from sport.db gem

class Game

  has_many :tips

  ##############
  ## move to sport.db gem ? why? why not?
  
  def job_running!
    @job_running = true
  end
  
  def job_done!
    @job_running = false
  end

  def job_running?
    (@job_running ||= false) == true
  end

  # move end
  ##########


  ###
  ## keep style helpers here? why? why not?


  def tip_1_style_class
    toto12x == '1' ? ' bingo ' : ' '
  end
  
  def tip_2_style_class
    toto12x == '2' ? ' bingo ' : ' '
  end
  
  def tip_x_style_class
    toto12x == 'X' ? ' bingo ' : ' '
  end
  
 
  ############ some methods for stats
  
  def complete_tips
    tips.where( 'toto12x is not null' )
  end

  def complete_tips_1
    tips.where( 'toto12x is not null' ).where( :toto12x => '1' ).order( 'score1 desc,score2 desc')
  end

  def complete_tips_2
    tips.where( 'toto12x is not null' ).where( :toto12x => '2' ).order( 'score2 desc,score1 desc')
  end
  
  def complete_tips_x
    tips.where( 'toto12x is not null' ).where( :toto12x => 'X' ).order( 'score1 desc,score2 desc')
  end
  
  
  def incomplete_tips
    tips.where( 'toto12x is null' )
  end
  
  def tip_1_count
    complete_tips.where( :toto12x => '1' ).count()
  end
  
  def tip_2_count
    complete_tips.where( :toto12x => '2' ).count()
  end
  
  def tip_x_count
    complete_tips.where( :toto12x => 'X' ).count()
  end
  
  def tip_12x_count
    complete_tips.count()
  end

end # class Game


end # module SportDB::Models