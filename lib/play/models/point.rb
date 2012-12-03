# encoding: utf-8

## NB: just use namespace SportDB::Models (not SportDB::Models::Play)

module SportDB::Models


class Point < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :pool
  belongs_to :round
  
  def round_pts_str
    buf = ''
    round_pts.times { buf << '♣' }
    buf
  end

  def total_pts_str
    buf = ''
    total_pts.times { buf << '♣' }
    buf
  end

  
  def diff_total_pos_style_class
    if diff_total_pos > 0
      ' ranking-up '
    elsif diff_total_pos < 0
      ' ranking-down '
    else  # == 0
      ' '
    end
  end
  
  def diff_total_pos_str
    ## todo: diff 2 use ⇑⇑
    #        diff 3 use ⇑⇑⇑
    #        diff 4 use ⇑⇑⇑⇑
    # etc.
    
    if diff_total_pos > 0
      "⇑#{diff_total_pos}"
    elsif diff_total_pos < 0
      "⇓#{diff_total_pos.abs}"
    else  # == 0
      ""
    end
  end

end  # class Point


end  # module SportDB::Models