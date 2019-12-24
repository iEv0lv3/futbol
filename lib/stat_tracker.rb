require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'game_teams'
require_relative 'season'
require_relative 'collection'
require_relative 'game_collection'
require_relative 'team_collection'
require_relative 'game_teams_collection'
require_relative 'season_collection'

class StatTracker
  attr_reader :game_collection,
              :team_collection,
              :season_collection,
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
    @season_collection = SeasonCollection.new(games)
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
    (home_wins / total_games.to_f).abs.round(2)
  end

  def percentage_visitor_wins
    visitor_wins = 0
    total_games = @game_collection.collection.length

    @game_collection.collection.each do |game|
      if game.home_goals.to_i < game.away_goals.to_i
        @game_collection.collection.each do |game|       
          if game[1].home_goals.to_i < game[1].away_goals.to_i
          visitor_wins += 1
          end
        end
    (visitor_wins / total_games.to_f).abs.round(2)
      end
    end
  end

  def lowest_scoring_visitor
    # team_ids_with_average_scores = {}

    # @game_teams_collection.collection.each do |team|
    #   if team_ids_with_average_scores.has_key?(team.last.team_id) && team.last.hoa == 'away'
    #     team_ids_with_average_scores[team.last.team_id] << team.last.goals.to_i
    #   elsif !team_ids_with_average_scores.has_key?(team.last.team_id) && team.last.hoa == 'away'
    #     team_ids_with_average_scores[team.last.team_id] = [team.last.goals.to_i]
    #   end
    # end

    # team_ids_with_average_scores.each do |team|
    # average_away_goals = team[1].sum / team[1].length
    # team_ids_with_average_scores[team[0]] = average_away_goals.to_s
    # end

  end

  def lowest_scoring_home_team
    average_scores = {}

    @game_teams_collection.collection.each do |team|
      if average_scores.has_key?(team.last.team_id) && team.last.hoa == 'home'
        average_scores[team.last.team_id] << team.last.goals.to_i
      elsif !average_scores.has_key?(team.last.team_id) && team.last.hoa == 'home'
        average_scores[team.last.team_id] = [team.last.goals.to_i]
      end
    end

    # average_scores.each do |team|
    #   averages = team[1].sum / team[1].length
    #   average_scores[team[0]] = averages.to_s
    # end

require 'pry'; binding.pry
  end

  # def winningest_team
  #   team_wins = []

  #   @game_collection.games.each do |game|
  #     if game.home_goals.to_i < game.away_goals.to_i
  #       team_wins << game.away_team_id.to_i
  #     elsif game.away_goals.to_i < game.home_goals.to_i
  #       team_wins << game.home_team_id.to_i
  #     end
  #   end

  #   team_wins.max_by {|i| team_wins.count(i)}
  # end

  # def best_fans
    # percentage_home_wins - percentage_visitor_wins.abs
  # end

  # def worst_fans
    # percentage_home_wins - percentage_visitor_wins.abs
  # end
end
