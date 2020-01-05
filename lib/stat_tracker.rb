require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'game_teams'
require_relative 'collection'
require_relative 'game_collection'
require_relative 'team_collection'
require_relative 'game_teams_collection'

class StatTracker
  attr_reader :game_collection,
              :team_collection,
              :game_teams_collection

  def self.from_csv(locations)
    games = locations[:games]
    teams = locations[:teams]
    game_teams = locations[:game_teams]

    StatTracker.new(games, teams, game_teams)
  end

  def initialize(games, teams, game_teams)
    @game_collection = GameCollection.new(games)
    @team_collection = TeamCollection.new(teams)
    @game_teams_collection = GameTeamsCollection.new(game_teams)
  end

  def average_goals_per_game
    sum = 0
    @game_collection.collection.each do |game|
      sum += (game[1].away_goals.to_i + game[1].home_goals.to_i)
    end
    (sum.to_f / @game_collection.collection.length).round(2)
  end

  def average_goals_by_season
    sums = {}
    averages = {}
    @game_collection.collection.each do |game|
      if !sums.key?(game[1].season)
        sums[game[1].season] = (game[1].home_goals.to_i + game[1].away_goals.to_i)
      else
        sums[game[1].season] += (game[1].home_goals.to_i + game[1].away_goals.to_i)
      end
    end

    sums.each do |key, value|
      averages[key] = (value.to_f / count_of_games_by_season[key]).round(2)
    end

    averages
  end

  def highest_total_score
    total_scores = @game_collection.collection.map do |game|
      game[1].away_goals.to_i + game[1].home_goals.to_i
    end
    total_scores.max
  end

  def lowest_total_score
    total_scores = @game_collection.collection.map do |game|
      game[1].away_goals.to_i + game[1].home_goals.to_i
    end
    total_scores.min
  end

  def biggest_blowout
    blowout = {}
    @game_collection.collection.each do |game|
      margin = (game[1].home_goals.to_i - game[1].away_goals.to_i).abs
      if blowout.empty?
        blowout[game[1]] = margin
      elsif margin > blowout.values[0]
        blowout.clear
        blowout[game[1]] = margin
      end
    end
    blowout.values.last
  end

  def count_of_games_by_season
    season = Hash.new(0)
    @game_collection.collection.each do |game|
      season[game[1].season] += 1
    end
    season
  end

  def percentage_ties
    ties_sum = 0.0
    @game_collection.collection.each do |game|
      ties_sum += 1 if game[1].home_goals == game[1].away_goals
    end
    (ties_sum / @game_collection.collection.length).round(2)
  end

  def percentage_home_wins
    home_wins = 0
    total_games = @game_collection.collection.length

    @game_collection.collection.each do |game|
      if game[1].home_goals.to_i > game[1].away_goals.to_i
        home_wins += 1
      end
    end
    (home_wins / total_games.to_f).round(2)
  end

  def percentage_visitor_wins
    visitor_wins = 0
    total_games = @game_collection.collection.length

    @game_collection.collection.each do |game|
      if game[1].home_goals.to_i < game[1].away_goals.to_i
          visitor_wins += 1
      end
    end
    (visitor_wins / total_games.to_f).round(2)
  end

  def lowest_scoring_visitor
    average_scores = {}

    @game_teams_collection.collection.each do |team|
      team_name = @team_collection.collection[team.last.team_id].team_name
      if average_scores.has_key?(team.last.team_id) && team.last.hoa == 'home'
        average_scores[team_name] << team.last.goals.to_i
      elsif !average_scores.has_key?(team.last.team_id) && team.last.hoa == 'home'
        average_scores[team_name] = [team.last.goals.to_i]
      end
    end

    average_scores.each do |team|
      averages = team[1].sum / team[1].length
      average_scores[team[0]] = averages.to_s
    end

    output = average_scores.max_by { |x|
      x.last.to_i
    }

    output.first
  end

  def lowest_scoring_home_team
    average_scores = {}

    @game_teams_collection.collection.each do |team|
      team_name = @team_collection.collection[team.last.team_id].team_name
      if average_scores.has_key?(team.last.team_id) && team.last.hoa == 'home'
        average_scores[team_name] << team.last.goals.to_i
      elsif !average_scores.has_key?(team.last.team_id) && team.last.hoa == 'home'
        average_scores[team_name] = [team.last.goals.to_i]
      end
    end

    average_scores.each do |team|
      averages = team[1].sum / team[1].length
      average_scores[team[0]] = averages.to_s
    end

    output = average_scores.min_by { |x|
      x.last.to_i
    }

    output.first
  end

  def winningest_team
    team_percentages = {}

    @game_teams_collection.collection.each do |team|
      team_name = @team_collection.collection[team.last.team_id].team_name

      if !team_percentages.has_key?(team_name)
        team_percentages[team_name] = [0,0,0]
        team_percentages[team_name][0] += 1
      elsif team_percentages.has_key?(team_name)
        team_percentages[team_name][0] += 1
      end

      if team.last.result == 'WIN'
        team_percentages[team_name][1] += 1
      elsif team.last.result == 'LOSS'
        team_percentages[team_name][2] += 1
      end
    end

    team_percentages.each do |team, results|
      team_win_average = results[1] / results[0].to_f
      team_percentages[team] = team_win_average.round(2)
    end

     final_output = team_percentages.max_by{|team, win_average| win_average}
     final_output.first
  end

  def best_fans
    team_percentages = {}

    @game_teams_collection.collection.each do |team|
      team_name = @team_collection.collection[team.last.team_id].team_name

      if !team_percentages.has_key?(team_name)
        team_percentages[team_name] = [0,0,0]
        team_percentages[team_name][0] += 1
      elsif team_percentages.has_key?(team_name)
        team_percentages[team_name][0] += 1
      end

      if team.last.hoa == 'home' && team.last.result == 'WIN'
        team_percentages[team_name][1] += 1
      elsif team.last.hoa == 'away' && team.last.result == 'WIN'
        team_percentages[team_name][2] += 1
      end
    end

    team_percentages.each do |team, results|
      team_home_win_average = results[1] / results[0].to_f
      team_away_win_average = results[2] / results[0].to_f
      team_averages_difference = team_home_win_average - team_away_win_average
      team_percentages[team] = team_averages_difference.abs.round(2)
    end

     final_output = team_percentages.max_by{|team, fans_average| fans_average}
     final_output.first
  end

#   def worst_fans
#     data_test_home = @game_teams_collection.collection.values.find_all { |a| a.hoa == "home"}
#     data_test_away = @game_teams_collection.collection.values.find_all { |a| a.hoa == "away"}
# require 'pry'; binding.pry
  #   team_percentages = {}

  #   @game_teams_collection.collection.each do |team|
  #     team_name = @team_collection.collection[team.last.team_id].team_name

  #     if !team_percentages.has_key?(team_name)
  #       team_percentages[team_name] = [0,0,0,0,0]
  #       team_percentages[team_name][0] += 1
  #     elsif team_percentages.has_key?(team_name)
  #       team_percentages[team_name][0] += 1
  #     end

  #     if team.last.hoa == 'home' && team.last.result == 'WIN'
  #       team_percentages[team_name][1] += 1
  #     elsif team.last.hoa == 'home' && team.last.result == 'LOSS'
  #       team_percentages[team_name][2] += 1
  #     elsif team.last.hoa == 'away' && team.last.result == 'WIN'
  #       team_percentages[team_name][3] += 1
  #     elsif team.last.hoa == 'away' && team.last.result == 'LOSS'
  #       team_percentages[team_name][4] += 1
  #     end
  #   end

  #   team_percentages.each do |team, results|
  #     team_home_win_average = results[1] / results[0].to_f
  #     team_home_loss_average = results[2] / results[0].to_f
  #     team_away_win_average = results[3] / results[0].to_f
  #     team_away_loss_average = results[4] / results[0].to_f
  #     # still can't access away games?
  #     team_percentages[team] = [team_home_win_average, team_home_loss_average, team_away_win_average, team_away_loss_average]
  #   end

  #    final_output = team_percentages
  #    final_output
  # end

  def biggest_bust(season_id)
    @game_collection.collection.values.each do |game|
      if game.season == season_id 
        

require 'pry'; binding.pry
    end


    
  end
end
