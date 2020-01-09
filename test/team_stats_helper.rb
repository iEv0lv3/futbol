require_relative 'calculateable'
require_relative 'gatherable'
require_relative 'season_stats'

module TeamStatsHelper
  include Gatherable
  include Calculateable
  include SeasonStats


  def team_season_wins_hash(team_id)
    percentage_seasons = Hash.new(0)
    @seasons.teams[team_id].each do |season|

      season_key = season[0]
      team_season = season[1].flatten
      stats = win_lose_draw_regular_season(team_id, team_season)
      final_percentage = best_worst_win_percentage(stats, team_id)
      percentage_seasons[season_key] = final_percentage[:win_percentage]
    end

    percentage_seasons
  end

  def best_worst_win_percentage(hash, team_id)
    total_games = (hash[:win] + hash[:loss] + hash[:draw])
    wins = hash[:win]
    percentage = ((wins.to_f / total_games) * 100).round(2)
    hash[:win_percentage] = percentage
    hash
  end

  def team_win_lose_draw_regular_season(team_id, team_season)
    record = { win: 0, loss: 0, draw: 0, regular_season_games: 0, win_percentage: 0, goals: 0, goals_against: 0 }
    team_season.reduce({}) do |hash, game|
      if team_id == game.home_team_id && (game.home_goals > game.away_goals) && game.type == 'Regular Season'
        record[:win] += 1
        record[:regular_season_games] += 1
        record[:goals] += game.home_goals.to_i
        record[:goals_against] += game.away_goals.to_i
      elsif team_id == game.home_team_id && (game.home_goals < game.away_goals) && game.type == 'Regular Season'
        record[:loss] += 1
        record[:regular_season_games] += 1
        record[:goals] += game.home_goals.to_i
        record[:goals_against] += game.away_goals.to_i
      elsif team_id == game.away_team_id && (game.away_goals > game.home_goals) && game.type == 'Regular Season'
        record[:win] += 1
        record[:regular_season_games] += 1
        record[:goals] += game.away_goals.to_i
        record[:goals_against] += game.home_goals.to_i
      elsif team_id == game.away_team_id && (game.away_goals < game.home_goals) && game.type == 'Regular Season'
        record[:loss] += 1
        record[:regular_season_games] += 1
        record[:goals] += game.away_goals.to_i
        record[:goals_against] += game.home_goals.to_i
      elsif game.home_goals == game.away_goals && game.type == 'Regular Season'
        record[:draw] += 1
        record[:regular_season_games] += 1
        record[:goals] += game.away_goals.to_i if team_id == game.away_team_id
        record[:goals] += game.home_goals.to_i if team_id == game.home_team_id
      end
      hash = record
      hash
    end
  end

  def team_win_lose_draw_postseason(team_id, team_season)
    record = { win: 0, loss: 0, draw: 0, postseason_games: 0, win_percentage: 0 }
    team_season.reduce({}) do |hash, game|
      if team_id == game.home_team_id && (game.home_goals > game.away_goals) && game.type == 'Postseason'
        record[:win] += 1
        record[:postseason_games] += 1
      elsif team_id == game.home_team_id && (game.home_goals < game.away_goals) && game.type == 'Postseason'
        record[:loss] += 1
        record[:postseason_games] += 1
      elsif team_id == game.away_team_id && (game.away_goals > game.home_goals) && game.type == 'Postseason'
        record[:win] += 1
        record[:postseason_games] += 1
      elsif team_id == game.away_team_id && (game.away_goals < game.home_goals) && game.type == 'Postseason'
        record[:loss] += 1
        record[:postseason_games] += 1
      elsif game.home_goals == game.away_goals && game.type == 'Postseason'
        record[:draw] += 1
        record[:postseason_games] += 1
      end
      hash = record
      hash
    end
  end

  def season_summary_regular_season_record(team_id)
    @seasons.teams[team_id].reduce({}) do |hash, season|
      next(hash) if season[1].nil?
      season_id = season[0]
      team_season = season[1].flatten
      hash[season[0]] = team_win_lose_draw_regular_season(team_id, team_season)
      season_summary_win_percentage(hash, season_id)
      hash
    end
  end

  def season_summary_postseason_record(season_id)
    @seasons.teams.reduce({}) do |hash, season|
      next(hash) if season[1][season_id].nil?
      team_id = season.first
      team_season = season[1][season_id].flatten
      hash[team_id] = team_win_lose_draw_postseason(season.first, team_season)
      team_season_win_percentage(hash, team_id)
      hash
    end
  end

  def season_summary_win_percentage(hash, season_id)
    total_games = (hash[season_id][:win] + hash[season_id][:loss] + hash[season_id][:draw])
    wins = hash[season_id][:win]
    percentage = ((wins.to_f / total_games) * 100).round(2)
    hash[season_id][:win_percentage] = percentage
    hash
  end

  def goal_difference(hash, game)
    hash[game[0]] = (game[1].home_goals.to_i - game[1].away_goals.to_i).abs
  end

  def all_team_games(team_id)
    @games.collection.find_all do |game|
      game[1].home_team_id == team_id || game[1].away_team_id == team_id
    end
  end

  def team_total_win_percentage(total_games, wins)
    (wins.to_f / total_games.size).round(2)
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

  def team_info_hash(team)
    {
      'team_id' => team.team_id,
      'franchise_id' => team.franchise_id,
      'team_name' => team.team_name,
      'abbreviation' => team.abbreviation,
      'link' => team.link
    }
  end
end
