require_relative 'calculateable'
require_relative 'gatherable'
require_relative 'season_stats'

module TeamStats
  include Gatherable
  include Calculateable
  include SeasonStats

  def favorite_opponent(team_id)
    team_wins = get_wins_by_opponent(team_id)
    team_games = get_total_games_by_opponent(team_id)
    team_average_by_opponent = get_average_by_opponent(team_wins, team_games)

    team_ident = team_average_by_opponent.max_by { |_opp_team, percent| percent }[0]
    team_name = get_team_name_by_id(team_ident)

    return team_name
  end

  def rival(team_id)
    team_wins = get_wins_by_opponent(team_id)
    team_games = get_total_games_by_opponent(team_id)
    team_average_by_opponent = get_average_by_opponent(team_wins, team_games)

    team_ident = team_average_by_opponent.min_by { |_opp_team, percent| percent }[0]
    team_name = get_team_name_by_id(team_ident)

    return team_name
  end

  def head_to_head(team_id)
    team_wins = get_wins_by_opponent(team_id)
    team_games = get_total_games_by_opponent(team_id)
    team_average_by_opponent = get_average_by_opponent(team_wins, team_games)

    avg_by_team_name = team_average_by_opponent.map do |key, value|
      [get_team_name_by_id(key), value]
    end.to_h

    avg_by_team_name.sort.to_h
  end

  def get_total_games_by_opponent(team_id)
    @games.collection.inject(Hash.new(0)) do |team_games, game|
      if game[1].home_team_id == team_id
        team_games[game[1].away_team_id] += 1
      elsif game[1].away_team_id == team_id
        team_games[game[1].home_team_id] += 1
      end
      team_games
    end
  end

  def get_wins_by_opponent(team_id)
    @games.collection.inject(Hash.new(0)) do |opp_wins, game|
      if (game[1].home_team_id == team_id) && (game[1].home_goals > game[1].away_goals)
        opp_wins[game[1].away_team_id] += 1
      elsif (game[1].away_team_id == team_id) && (game[1].away_goals > game[1].home_goals)
        opp_wins[game[1].home_team_id] += 1
      end
      opp_wins
    end
  end

  def get_average_by_opponent(team_wins, team_games)
    team_wins.inject(Hash.new(0)) do |win_perc, win|
      win_perc[win.first] = (win.last.to_f / team_games[win.first]).round(2)
      win_perc
    end
  end

  def team_info(team_id)
    team = @teams.collection[team_id]
    team_info_hash(team)
  end

  def average_win_percentage(team_id)
    total_games = all_team_games(team_id)
    wins = 0
    total_games.each do |game|
      the_result = game_win_loss_draw(game, team_id)
      wins += the_result
    end
    team_total_win_percentage(total_games, wins)
  end

  def biggest_team_blowout(team_id)
    total_games = all_team_games(team_id)
    wins = total_games.reduce(Hash.new(0)) do |hash, game|
      the_result = game_win_loss_draw(game, team_id)
      goal_difference(hash, game) if the_result == 1
      hash
    end
    wins.max_by { |_k, v| v }[1]
  end

  def most_goals_scored(team_id)
    team_goals = []
    @games.collection.each do |game|
      if game.last.home_team_id == team_id
        team_goals << game.last.home_goals.to_i
      elsif game.last.away_team_id == team_id
        team_goals << game.last.away_goals.to_i
      end
    end
    team_goals.max
  end

  def fewest_goals_scored(team_id)
    team_goals = []
    @games.collection.each do |game|
      if game.last.home_team_id == team_id
        team_goals << game.last.home_goals.to_i
      elsif game.last.away_team_id == team_id
        team_goals << game.last.away_goals.to_i
      end
    end
    team_goals.min
  end

  def worst_loss(team_id)
    team_goal_diff = []
    @games.collection.each do |game|
      if game.last.home_team_id == team_id && game.last.home_goals < game.last.away_goals
        team_goal_diff << game.last.away_goals.to_i - game.last.home_goals.to_i
      elsif game.last.away_team_id == team_id && game.last.away_goals < game.last.home_goals
        team_goal_diff << game.last.home_goals.to_i - game.last.away_goals.to_i
      end
    end
    team_goal_diff.max
  end

  def season_summary(team_id)
    require 'pry'; binding.pry

    # win percentage: post/reg
    # total_goals_scored: post/reg
    # total_goals_against: post_reg
    # avg_goals_scored: post/reg
    # avg_goals_against: post/reg
    # general structure
    #   'season_id' => {
    #       :postseason => {
    #           :win_percent => float
    #           :total_goals_against => float
    #       }
    #    }
    regular_record = team_regular_season_record(team_id, season_id)
  end

  def best_season(team_id)
    final_percentage = team_season_wins_hash(team_id)
    answer = final_percentage.max_by{|season, win_percentage| win_percentage}
    answer[0]
  end

  def worst_season(team_id)
    final_percentage = team_season_wins_hash(team_id)
    answer = final_percentage.min_by{|season, win_percentage| win_percentage}
    answer[0]
  end

end
