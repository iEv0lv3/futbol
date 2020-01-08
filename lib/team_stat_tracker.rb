require 'csv'
require_relative 'tracker'
require_relative './modules/calculateable'
require_relative './modules/gatherable'
require_relative './modules/team_stats'

class TeamStatTracker < Tracker
  include Calculateable
  include Gatherable
  include TeamStats

  def initialize
    super
  end

  def team_info(team_id)
    team = @teams.collection[team_id]
    team_info_hash(team)
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

  def average_win_percentage(team_id)
    total_games = all_team_games(team_id)
    wins = 0
    total_games.each do |game|
      the_result = game_win_loss_draw(game, team_id)
      wins += the_result
    end
    team_total_win_percentage(total_games, wins)
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

  def favorite_opponent(team_id)
    team_wins = get_wins_by_opponent(team_id)
    team_games = get_total_games_by_opponent(team_id)
    team_average_by_opponent = get_average_by_opponent(team_wins, team_games)

    team_ident = team_average_by_opponent.max_by { |_opp_team, percent| percent }[0]
    team_name = get_team_name_by_id(team_ident)

    team_name
  end

  def rival(team_id)
    team_wins = get_wins_by_opponent(team_id)
    team_games = get_total_games_by_opponent(team_id)
    team_average_by_opponent = get_average_by_opponent(team_wins, team_games)

    team_ident = team_average_by_opponent.min_by { |_opp_team, percent| percent }[0]
    team_name = get_team_name_by_id(team_ident)

    return team_name
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

  def head_to_head(team_id)
    team_wins = get_wins_by_opponent(team_id)
    team_games = get_total_games_by_opponent(team_id)
    team_average_by_opponent = get_average_by_opponent(team_wins, team_games)

    avg_by_team_name = team_average_by_opponent.map do |key, value|
      [get_team_name_by_id(key), value]
    end.to_h

    avg_by_team_name.sort.to_h
  end

  def seasonal_summary(team_id)
    data = @games.collection.inject({}) do |seasons, game|
      seasons[game[1].season] = {
        postseason: {
          win_percentage: team_postseason_win_percent(seasonal_wins_by_team(game[1].season, 'Postseason'))[team_id], # function
          total_goals_scored: get_total_goals_scored(game[1].season, 'Postseason')[team_id],
          total_goals_against: get_total_goals_against(game[1].season, 'Postseason')[team_id], # function
          average_goals_scored: 0, # function
          average_goals_against: 0 # function
        },
        regular_season: {
          win_percentage: 0, # function
          total_goals_scored: get_total_goals_scored(game[1].season, 'Regular Season')[team_id], # function
          total_goals_against: get_total_goals_against(game[1].season, 'Regular Season')[team_id], # function
          average_goals_scored: 0, # function
          average_goals_against: 0 # function
        }
      }
      seasons
    end
    require 'pry'; binding.pry
  end
end
