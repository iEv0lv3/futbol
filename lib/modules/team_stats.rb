require_relative 'calculateable'
require_relative 'gatherable'
require_relative 'season_stats'

module TeamStats
  include Gatherable
  include Calculateable
  include SeasonStats

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

  def team_info_hash(team)
    {
      'team_id' => team.team_id,
      'franchise_id' => team.franchise_id,
      'team_name' => team.team_name,
      'abbreviation' => team.abbreviation,
      'link' => team.link
    }
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

  def goal_difference(hash, game)
    hash[game[0]] = (game[1].home_goals.to_i - game[1].away_goals.to_i).abs
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

  def get_total_goals_scored(season, type)
    @games.collection.inject(Hash.new(0)) do |goals, game|
      if game[1].season == season && game[1].type == type
        goals[game[1].home_team_id] += game[1].home_goals.to_i
        goals[game[1].away_team_id] += game[1].away_goals.to_i
      end
      goals
    end
  end

  def get_total_goals_against(season, type)
    @games.collection.inject(Hash.new(0)) do |goals, game|
      if game[1].season == season && game[1].type == type
        goals[game[1].home_team_id] += game[1].away_goals.to_i
        goals[game[1].away_team_id] += game[1].home_goals.to_i
      end
      goals
    end
  end

  def seasonal_wins_by_team(season, type)
    @games.collection.inject(Hash.new(0)) do |wins, game|
      if game[1].season == season && game[1].type == type && game[1].home_goals.to_i > game[1].away_goals.to_i
        wins[game[1].home_team_id] += 1
      elsif game[1].season == season && game[1].type == type && game[1].away_goals.to_i > game[1].home_goals.to_i
        wins[game[1].home_team_id] += 1
      end
      wins
    end
  end
end
