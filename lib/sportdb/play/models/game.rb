


module SportDb::Models


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
    toto1x2 == '1' ? ' bingo ' : ' '
  end

  def tip_2_style_class
    toto1x2 == '2' ? ' bingo ' : ' '
  end

  def tip_x_style_class
    toto1x2 == 'X' ? ' bingo ' : ' '
  end
  
 
  ############ some methods for stats
  
  def complete_tips()   tips.complete;  end
  def complete_tips_1() tips.complete1.order( 'score1 desc,score2 desc');  end
  def complete_tips_2() tips.complete2.order( 'score2 desc,score1 desc');  end
  def complete_tips_x() tips.completex.order( 'score1 desc,score2 desc');  end

  def incomplete_tips() tips.incomplete;  end

  def tip_1_count()     tips.complete1.count();  end
  def tip_2_count()     tips.complete2.count();  end
  def tip_x_count()     tips.completex.count();  end

  def tip_12x_count()   tips.commplete.count();  end
  def tip_1x2_count()   tips.commplete.count();  end   # alias for tip_12x_count // or just add/use tip_count add too??


end # class Game


end # module SportDb::Models
