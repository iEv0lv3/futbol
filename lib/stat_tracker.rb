# frozen_string_literal: true
require 'csv'

class StatTracker
  attr_reader :games_collection, :teams_collection, :game_teams_collection

  def initialize(games, teams)
    @games_collection = games
    @teams_collection = teams
    # @game_team = game_team
  end

  def percentage_home_wins
    home_wins = 0
    total_games = @games_collection.games.length

    @games_collection.games.each do |game|
      if game.home_goals.to_i > game.away_goals.to_i
        home_wins += 1
      end
    end
    (home_wins / total_games.to_f).abs.round(2)
  end

  def percentage_visitor_wins
    visitor_wins = 0
    total_games = @games_collection.games.length

    @games_collection.games.each do |game|       
      if game.home_goals.to_i < game.away_goals.to_i
        visitor_wins += 1
      end
    end
    (visitor_wins / total_games.to_f).abs.round(2)
  end

  def initialize(games_collection, teams_collection)
    @games_collection = games_collection
    @teams_collection = teams_collection
    # @game_team = game_team
  end

  def highest_total_score
    total_scores = @games_collection.games.map do |game|
      game.away_goals.to_i + game.home_goals.to_i
    end
    total_scores.max
  end

  def lowest_total_score
    total_scores = @games_collection.games.map do |game|
      game.away_goals.to_i + game.home_goals.to_i
    end
    total_scores.min
  end
end
