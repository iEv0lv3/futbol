require_relative 'calculateable'
require_relative 'gatherable'
require_relative 'season_stats'

module TeamStats
  include Gatherable
  include Calculateable
  include SeasonStats

  def best_season(team_id)
    final_percentage = team_season_wins_hash(team_id)
    answer = final_percentage.max_by{|season,win_percentage| win_percentage}
    answer[0]
  end

  def worst_season(team_id)
    final_percentage = team_season_wins_hash(team_id)
    answer = final_percentage.min_by{|season,win_percentage| win_percentage}
    answer[0]
  end

  def team_season_wins_hash(team_id)
    percentage_seasons = Hash.new(0)
    @seasons.teams[team_id].each do |season|
      season_key = season[0]
      team_season = season[1].flatten!
      stats = win_lose_draw_regular_season(team_id, team_season)
      final_percentage = team_season_win_percentage(stats, team_id)
      percentage_seasons[season_key] = final_percentage[:win_percentage]
    end

    percentage_seasons
  end

  def team_season_win_percentage(hash, team_id)
    total_games = (hash[:win] + hash[:loss] + hash[:draw])
    wins = hash[:win]
    percentage = ((wins.to_f / total_games) * 100).round(2)
    hash[:win_percentage] = percentage
    hash
require_relative './calculateable'
require_relative './gatherable'

module TeamStats
  include Calculateable
  include Gatherable

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

  def team_info_hash(team)
    {
      'team_id' => team.team_id,
      'franchise_id' => team.franchise_id,
      'team_name' => team.team_name,
      'abbreviation' => team.abbreviation,
      'link' => team.link
    }
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

  def all_team_games(team_id)
    @games.collection.find_all do |game|
      game[1].home_team_id == team_id || game[1].away_team_id == team_id
    end
  end

  def game_win_loss_draw(game, team_id)
    hoa = team_id_home_or_away(game, team_id)
    result = game[1].home_goals <=> game[1].away_goals
    if result == -1 && hoa == 'away'
      1
    elsif result == 1 && hoa == 'home'
      1
    else
      0
    end
  end

  def team_id_home_or_away(game, team_id)
    return 'home' if game[1].home_team_id == team_id
    return 'away' if game[1].away_team_id == team_id
  end

  def team_total_win_percentage(total_games, wins)
    (wins.to_f / total_games.size).round(2)
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

  def goal_difference(hash, game)
    hash[game[0]] = (game[1].home_goals.to_i - game[1].away_goals.to_i).abs
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

  def best_season(team_id)
    final_percentage = team_season_wins_hash(team_id)
    answer = final_percentage.max_by{|season,win_percentage| win_percentage}
    answer[0]
  end

  def worst_season(team_id)
    final_percentage = team_season_wins_hash(team_id)
    answer = final_percentage.min_by{|season,win_percentage| win_percentage}
    answer[0]
  end

  def team_season_wins_hash(team_id)
    percentage_seasons = Hash.new(0)
    @seasons.teams[team_id].each do |season|
      season_key = season[0]
      team_season = season[1].flatten!
      stats = win_lose_draw_regular_season(team_id, team_season)
      final_percentage = team_season_win_percentage(stats, team_id)
      percentage_seasons[season_key] = final_percentage[:win_percentage]
    end

    percentage_seasons
  end

  def team_season_win_percentage(hash, team_id)
    total_games = (hash[:win] + hash[:loss] + hash[:draw])
    wins = hash[:win]
    percentage = ((wins.to_f / total_games) * 100).round(2)
    hash[:win_percentage] = percentage
    hash
  end 
end
