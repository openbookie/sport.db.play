
module SportDb
  module Market

### load quotes from plain text files

class Reader

  include LogUtils::Logging

## make models available in sportdb module by default with namespace
#  e.g. lets you use Team instead of Model::Team 
  include SportDb::Models

  attr_reader :include_path
  attr_reader :loader

  def initialize( include_path )
    @include_path = include_path
    @loader       = Loader.new( include_path )
  end

  def load_setup( name )
    path = "#{include_path}/#{name}.yml"

    logger.info "parsing data '#{name}' (#{path})..."

    reader = FixtureReader.new( path )

    reader.each do |fixture_name|
      load( fixture_name )
    end
  end # method load_setup


  def load( name )   # convenience helper for all-in-one reader

    logger.debug "enter load( name=>>#{name}<<, include_path=>>#{include_path}<<)"
    
    # check if name exits if extension .rb  ##
    #  if yes, use loader (for ruby code)
    #  otherwise assume
    #  plain text match/game quotes
    
    ## todo: add sub for !/ prefix in name

    path = "#{@include_path}/#{name}.rb"
    
    if File.exist?( path )   # if it's ruby use (code) loader
      loader.load( name )
    else
      meta = fetch_quotes_meta( name )
 
      service_key = meta['service_key']
      event_key   = "#{meta['league_key']}.#{meta['season_key']}"
      
      load_quotes( service_key, event_key, name )
    end

  end  # method load



  def fetch_quotes_meta( name )
    # get/fetch/find event from yml file

    ## todo/fix: use h = HashFile.load( path ) or similar instead of HashReader!!

    ## todo/fix: add option for not adding prop automatically?? w/ HashReaderV2

    reader = HashReaderV2.new( name, include_path )

    attribs = {}

    reader.each_typed do |key, value|

      ## puts "processing event attrib >>#{key}<< >>#{value}<<..."

      if key == 'league'
        attribs[ 'league_key' ] = value.to_s.strip
      elsif key == 'season'
        attribs[ 'season_key' ] = value.to_s.strip
      elsif key == 'service'
        attribs[ 'service_key' ] = value.to_s.strip
      else
        puts "*** warn: skipping unknown quote config/meta key >#{key}< w/ value >#{value}<"
      end
    end # each key,value
    
    attribs
  end



  def load_quotes( service_key, event_key, name )
    path = "#{@include_path}/#{name}.txt"

    puts "*** parsing data '#{name}' (#{path})..."

    ### todo/fix: use classify  (from string)
    SportDb.lang.lang = SportDb.lang.classify_file( path )

    reader = LineReader.new( path )

    load_worker( service_key, event_key, reader )

    ## Prop.create!( key: "db.#{fixture_name_to_prop_key(name)}.version", value: "file.txt.#{File.mtime(path).strftime('%Y.%m.%d')}" )
  end

private


  def load_worker( service_key, event_key, reader )

    ## assume active activerecord connection
    ##
    
    @service = Service.find_by_key!( service_key )
    
    #### fix:
    ## for now skip if event not present
    @event   = Event.find_by_key( event_key )
    
    unless @event.present?
      puts "*** error: event key >>#{event_key}<< not found/present; skip loading quotes"
      return
    end

    puts "Quote Service #{@service.key} >#{@service.title}<"
    puts "Event #{@event.key} >#{@event.title}<"
    
    @known_teams = @event.known_teams_table
    
    parse_quotes( reader )

  end   # method load


  include SportDb::FixtureHelpers


  def find_handicap!( line )
    # fix/todo:
    #   use find_handicap_team1! and
    #       find_handicap_team2!  ??? why? why not??
    #   how can we know if the handicap is for team1 or team2
    #    needs to get fixed; find some
    
    # for now ignore handicap  e.g. +1 or +2 or +3 +4 +5
    
    regex = /\+(\d)[ \t]+/
    
    match = regex.match( line )
    unless match.nil?
      value = match[1].to_i
      puts "   handicap: >#{value}<"
      
      line.sub!( regex, ' [HANDICAP] ' )

      return value
    end
    nil # if no handicap found
  end


  def find_quotes!( line )
    # extract quotes triplet from line
    # and return it
    # NB: side effect - removes quotes triplet from line string
    
    # e.g. 1,55  3,55  6,44
    
    # NB: (?:)  is used for non-capturing grouping
    
    ## regex1 uses point., e.g. 1.55 for separator
    ## regex2 uses comma-, e.g. 1,55 for separator

    
    regex1 = /[ \t]+(\d{1,3}(?:\.\d{1,3})?)[ \t]+(\d{1,3}(?:\.\d{1,3})?)[ \t]+(\d{1,3}(?:\.\d{1,3})?)/
    regex2 = /[ \t]+(\d{1,3}(?:,\d{1,3})?)[ \t]+(\d{1,3}(?:,\d{1,3})?)[ \t]+(\d{1,3}(?:,\d{1,3})?)/
    
    match = regex1.match( line )
    unless match.nil?
      values = [match[1].to_f, match[2].to_f, match[3].to_f]
      puts "   quotes: >#{values.join('|')}<"
      
      line.sub!( regex1, ' [QUOTES.EN]' )

      return values
    end
    
    match = regex2.match( line )
    unless match.nil?
      values = [match[1].tr(',','.').to_f,
                match[2].tr(',','.').to_f,
                match[3].tr(',','.').to_f]
      puts "   quotes: >#{values.join('|')}<"
      
      line.sub!( regex2, ' [QUOTES.DE]' )

      return values
    end
    
    nil  # return nil; nothing found
  end


  def parse_quotes( reader )
    
    reader.each_line do |line|
  
      if is_round?( line )
        puts "parsing round line: >#{line}<"
        pos = find_round_pos!( line )
        puts "  line: >#{line}<"
        
        @round = Round.find_by_event_id_and_pos!( @event.id, pos )

        
      else
        puts "parsing game (fixture) line: >#{line}<"
        
        match_teams!( line )
        team1_key = find_team1!( line )
        team2_key = find_team2!( line )

        handicap = find_handicap!( line )

        quotes = find_quotes!( line )

        puts "  line: >#{line}<"

        if quotes.nil?
          puts 'no quotes found; skipping line'  # skip lines w/o quotes
          next
        end
        


        ### todo: cache team lookups in hash?

        team1 = Team.find_by_key!( team1_key )
        team2 = Team.find_by_key!( team2_key )

        ### check if games exists
        ##  with this teams in this round if yes only update
        game = Game.find_by_round_id_and_team1_id_and_team2_id!(
                         @round.id, team1.id, team2.id
        )
        
        quote_attribs = {
          odds1: quotes[0],
          oddsx: quotes[1],
          odds2: quotes[2]
        }
        
        quote = Quote.find_by_service_id_and_game_id( @service.id, game.id )

        if quote.present?
          puts "*** update quote #{quote.id}:"
        else
          puts "*** create quote:"
          quote = Quote.new
          
          more_quote_attribs = {
            service_id:  @service.id,
            game_id:     game.id
          }
          quote_attribs = quote_attribs.merge( more_quote_attribs )
        end

        puts quote_attribs.to_json

        quote.update_attributes!( quote_attribs )
      end
    end # each lines
    
  end # method parse_quotes

end # class Reader

  end # module Market
end # module SportDb
