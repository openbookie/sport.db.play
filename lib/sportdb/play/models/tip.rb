# encoding: utf-8


## NB: just use namespace SportDb::Models (not SportDb::Models::Play)

module SportDb::Models


class Tip < ActiveRecord::Base

  belongs_to :user
  belongs_to :pool
  belongs_to :game

  before_save :calc_winner


  def calc_winner
    if score1.nil? || score2.nil?
      self.winner90 = nil
      self.winner   = nil
    else
      if score1 > score2
        self.winner90 = 1
      elsif score1 < score2
        self.winner90 = 2
      else # assume score1 == score2 - draw
        self.winner90 = 0
      end

      ## todo/fix:
      #  check for next-game/pre-game !!!
      #    use 1st leg and 2nd leg - use for winner too
      #  or add new winner_total or winner_aggregated method ???

      ## check for penalty  - note: some games might only have penalty and no extra time (e.g. copa liberatadores)
      if score1p.present? && score2p.present?
        if score1p > score2p
          self.winner = 1
        elsif score1p < score2p
          self.winner = 2
        else
          # issue warning! - should not happen; penalty goes on until winner found!
          puts "*** warn: should not happen; penalty goes on until winner found"
        end
      ## check for extra time
      elsif score1et.present? && score2et.present?
        if score1et > score2et
          self.winner = 1
        elsif score1et < score2et
          self.winner = 2
        else # assume score1et == score2et - draw
          self.winner = 0
        end
      else
        # assume no penalty and no extra time; same as 90min result
        self.winner = self.winner90
      end
    end
  end


 ############ some scopes for stats
 
 # -- for now always use winner90 (that is, after 90 mins; not extra time or penality etc.)

  scope :complete,  -> { where( 'winner90 is not null' ) }
  scope :complete1, -> { where( 'winner90 is not null' ).where( winner90: 1 ) }
  scope :complete2, -> { where( 'winner90 is not null' ).where( winner90: 2 ) }
  scope :completex, -> { where( 'winner90 is not null' ).where( winner90: 0 ) }
  scope :complete0, -> { where( 'winner90 is not null' ).where( winner90: 0 ) }  # alias for completex
 
  scope :incomplete, -> { where( 'winner90 is null' ) }


  def toto12x() toto1x2; end # alias for toto12x - todo/fix: use ruby alias helper
  def toto1x2
    ## note: will return string e.g. 1-X-2 (winner will return int e.g. 1-0-2)
    
    ## fix: use switch/when expr/stmt instead of ifs
    value = winner90   # 1 0 2  1 => team 1 0 => draw 2 => team
    if value == 0
      'X'
    elsif value == 1
      '1'
    elsif value == 2
      '2'
    elsif value == -1
      nil  # ??? - unknown -- include --??? why? why not??
    else
      nil
    end
  end


  ### getter/setters for deprecated attribs (score3,4,5,6)

  def score3
    score1et
  end

  def score4
    score2et
  end
  
  def score1ot
    score1et
  end

  def score2ot
    score2et
  end

  def score5
    score1p
  end

  def score6
    score2p
  end

  def score3=(value)
    self.score1et = value
  end

  def score4=(value)
    self.score2et = value
  end

  def score1ot=(value)
    self.score1et = value
  end

  def score2ot=(value)
    self.score2et = value
  end

  def score5=(value)
    self.score1p = value
  end

  def score6=(value)
    self.score2p = value
  end



  ## todo: rename to find_by_play_and_game ????
  def self.find_by_user_and_pool_and_game( user_arg, pool_arg, game_arg )
    recs = self.where( user_id: user_arg.id,
                       pool_id: pool_arg.id,
                       game_id: game_arg.id )
    recs.first
  end


  def export?
    # check if user entered some data
    # - do NOT export nil records (all scores blank)
    
    (score1.blank?   && score2.blank?   &&
     score1et.blank? && score2et.blank? &&
     score1p.blank?  && score2p.blank?) == false
  end


  def calc_points_worker
    pts = 0

      if(((game.score1 == game.score2) && (score1 == score2)) ||
         ((game.score1 >  game.score2) && (score1 >  score2)) ||
         ((game.score1 <  game.score2) && (score1 <  score2)))
          pts += 1
      end

      # tordifferenz richtig? todo: auch fuer unentschieden???
      if((game.score1-game.score2) == (score1-score2))
        ## nb: for now now points for tordifferenz
        ### pts +=1
      end

      # ergebnis richtig?
      if game.score1 == score1 && game.score2 == score2
        pts += 2
      else
        # 2nd chance!
        # -- check 4+ rule for result
        if( [game.score1,4].min == [score1,4].min &&
            [game.score2,4].min == [score2,4].min )
          pts += 2
        end
      end


      ## check n.V. - after extra time/a.e.t

      if( game.score1et.present? && game.score2et.present? && score1et.present? && score2et.present?)
        
         if(((game.score1et == game.score2et) && (score1et == score2et)) ||
            ((game.score1et >  game.score2et) && (score1et >  score2et)) ||
            ((game.score1et <  game.score2et) && (score1et <  score2et)))
                pts += 1
         end
      end

      ## check i.E.

      if( game.score1p.present? && game.score2p.present? && score1p.present? && score2p.present?)
            
         if(((game.score1p > game.score2p) && (score1p > score2p)) ||
            ((game.score1p < game.score2p) && (score1p < score2p)))
                pts += 1
         end
      end
    
    pts
  end


  def calc_points
    pts = 0
    pts = calc_points_worker()  if complete?
    pts
  end

  def calc_points_str
    buf = ''
    calc_points.times { buf << '♣' }
    buf
  end

  
  ## todo: use tip-fail, tip-bingo, etc.
  
  def bingo_style_class
    if incomplete?
      # show missing label for upcoming games only
      if game.over?
        ''
      elsif score1.blank? || score2.blank?
        'missing'  # missing tip scores
      else
        ''  # tip scores filled in; game scores not yet available
      end
    else
      pts = calc_points()
      if pts == 0
        'fail'
      elsif pts == 1
        'bingo'
      elsif pts == 2
        'bingoo'
      elsif pts == 3
        'bingooo'
      else
        ''  # unknown state; return empty (css) class
      end
    end
  end

  # like bingo_style_class but only for pts>0 (that is not for fail)
  def bingo_win_style_class
    if incomplete?
      # show missing label for upcoming games only
      if game.over?
        ''
      elsif score1.blank? || score2.blank?
        'missing'  # missing tip scores
      else
        ''  # tip scores filled in; game scores not yet available
      end
    else
      pts = calc_points()
      if pts == 0
        ''
      elsif pts == 1
        'bingo'
      elsif pts == 2
        'bingoo'
      elsif pts == 3
        'bingooo'
      else
        ''  # unknown state; return empty (css) class
      end
    end
  end

  def bingo_text
    if incomplete?
      # show missing label for upcoming games only
      if game.over?
        ''
      elsif score1.blank? || score2.blank?
        '?'  # missing tip scores
      else
        ''  # tip scores filled in; game scores not yet available
      end
    else
      pts = calc_points()
      if pts == 0
### FIX: - make extendable how?
###        if game.calc? && (game.team1_id != calc_team1_id || game.team2_id != calc_team2_id )
##          ## sorry, wrong teams - show team1 n team2 tags
##          "× Leider, nein. Richtige Spielpaarung (#{game.team1.tag}) - (#{game.team2.tag})."
##        else
          "× Leider, nein. Richtiger Tipp #{game.toto12x}."  # return 1,2,X from game
##        end
      elsif pts == 1
        '♣ 1 Pkt - Ja!'
      elsif pts == 2
        '♣♣ 2 Pkte - Jaaa!'
      elsif pts == 3
        '♣♣♣ 3 Pkte - Jaaaaa!'
      else
        ''  # unknown state; return empty (css) class
      end
    end
  end


  def complete?
    game.score1.present? && game.score2.present? && score1.present? && score2.present?
  end

  def incomplete?
    complete? == false
  end
  
  def locked?
###  FIX: make extendable  (pool.fix? only in addon??)
###     return true if pool.fix? && pool.locked?  # if fix pool is locked all games are (automatically) locked too
    return true if pool.locked?
    game.locked?
  end
  
  def public?
    return true if pool.public? 
    return true if locked?       # if fix pool is locked or game (make tip public)
    
    ## todo: use builtin utc.past? method ???
    Time.now.utc > game.play_at.utc
  end

  def score_str

    ## fix: check game
    #  use buf and allow result90 plus penalty only too

    ## fix: use new game.toto12x instead of game.over ??? (doesn't depend on time) 
    if score1.blank? && score2.blank? && game.over?
      # return no data marker (e.g. middot) if not touched by user
      '·'
    else
      str = ''
      if score1p.present? && score2p.present?    # im Elfmeterschiessen i.E.?
        str = "#{score1_str} : #{score2_str} / #{score1et} : #{score2et} n.V. / #{score1p} : #{score2p} i.E."
      elsif score1et.present? && score2et.present?  # nach Verlaengerung n.V.?
        str = "#{score1_str} : #{score2_str} / #{score1et} : #{score2et} n.V."
      else
        str = "#{score1_str} : #{score2_str}"
      end
 
##### FIX: make extendable!!
#      if calc
#        str_calc_team1 = calc_team1_id.blank? ? '' : calc_team1.tag
#        str_calc_team2 = calc_team2_id.blank? ? '' : calc_team2.tag
#        str = "(#{str_calc_team1}) #{str} (#{str_calc_team2})"
#      end
      str
    end
  end

  def score1_str()  score1.blank?  ? '?' : score1.to_s;  end
  def score2_str()  score2.blank?  ? '?' : score2.to_s;  end

end # class Tip

end  # module SportDb::Models
