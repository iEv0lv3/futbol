require 'csv'

class StatTracker
  attr_reader :games_collection, :teams_collection, :game_teams_collection

  def initialize(games_collection, teams_collection)
    @games_collection = games_collection
    @teams_collection = teams_collection
    # @game_team = game_team
  end

  def average_goals_per_game
    sum = 0

    @games_collection.games.each do |game|
      sum += (game.away_goals.to_i + game.home_goals.to_i)
    end

    (sum.to_f / @games_collection.games.length).round(2)
  end

  def average_goals_by_season
    sums = {}
    averages = {}

    @games_collection.games.each do |game|
      if !sums.key?(game.season)
        sums[game.season] = (game.home_goals.to_i + game.away_goals.to_i)
      else
        sums[game.season] += (game.home_goals.to_i + game.away_goals.to_i)
      end
    end

    sums.each do |key, value|
      averages[key] = (value.to_f / count_of_games_by_season[key]).round(2)
    end

    averages
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

  def biggest_blowout
    blowout = {}
    
    @games_collection.games.find_all do |game|
      margin = (game.home_goals.to_i - game.away_goals.to_i).abs
      if blowout.empty?
        blowout[game] = margin
      elsif margin > blowout.values[0]
        blowout.clear
        blowout[game] = margin
      end
    end
    blowout.values.last
  end

  def count_of_games_by_season
    season = Hash.new(0)

    @games_collection.games.each do |game|
      season[game.season] += 1
    end
    season
  end

  def percentage_ties
    ties_sum = 0.0
    @games_collection.games.each do |game|
      ties_sum += 1 if game.home_goals == game.away_goals
    end
    (ties_sum / @games_collection.games.length).round(2)
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

  def count_of_teams
    @teams_collection.teams.each do |team|
      team
    end.length
  end

  def best_offense
    goals_scored = Hash.new(0)

    @games_collection.games.map do |game|
      if goals_scored.has_key?(game.away_team_id)
        goals_scored[game.away_team_id] << game.away_goals.to_i
      elsif !goals_scored.has_key?(game.away_team_id)
        goals_scored[game.away_team_id] = [game.away_goals.to_i]
      end
    end
    @games_collection.games.map do |game|
      if goals_scored.has_key?(game.home_team_id)
        goals_scored[game.home_team_id] << game.home_goals.to_i
      elsif !goals_scored.has_key?(game.home_team_id)
        goals_scored[game.home_team_id] = [game.home_goals.to_i]
      end
    end
    team_names_ids = Hash.new(0)

    @teams_collection.teams.each do |team|
      team_names_ids[team.team_id] = team.abbreviation
    end
      goals_scored.each do |team|
        goals_scored_averages = team[1].sum / team[1].length
        goals_scored[team[0]] = goals_scored_averages
    end
    team_id_max_goals = goals_scored.max_by{ |k, v| v}
    team_names_ids[team_id_max_goals[0]]
  end

  def worst_offense
    goals_scored = Hash.new(0)

    @games_collection.games.each do |game|
      if goals_scored.has_key?(game.away_team_id)
        goals_scored[game.away_team_id] << game.away_goals.to_i
      elsif !goals_scored.has_key?(game.away_team_id)
        goals_scored[game.away_team_id] = [game.away_goals.to_i]
      end
    end
    @games_collection.games.map do |game|
      if goals_scored.has_key?(game.home_team_id)
        goals_scored[game.home_team_id] << game.home_goals.to_i
      elsif !goals_scored.has_key?(game.home_team_id)
        goals_scored[game.home_team_id] = [game.home_goals.to_i]
      end
    end
    team_names_ids = Hash.new(0)

    @teams_collection.teams.each do |team|
      team_names_ids[team.team_id] = team.abbreviation
    end
      goals_scored.each do |team|
        goals_scored_averages = team[1].sum / team[1].length
        goals_scored[team[0]] = goals_scored_averages
    end
    team_id_max_goals = goals_scored.min_by{ |k, v| v}
    team_names_ids[team_id_max_goals[0]]
  end

  def best_defense
    goals_allowed = Hash.new(0)

    @games_collection.games.each do |game|
      if goals_allowed.has_key?(game.away_team_id)
        goals_allowed[game.away_team_id] << game.home_goals.to_i
      elsif !goals_allowed.has_key?(game.away_team_id)
        goals_allowed[game.away_team_id] = [game.home_goals.to_i]
      end
    end
    @games_collection.games.map do |game|
      if goals_allowed.has_key?(game.home_team_id)
        goals_allowed[game.home_team_id] << game.away_goals.to_i
      elsif !goals_allowed.has_key?(game.home_team_id)
        goals_allowed[game.home_team_id] = [game.away_goals.to_i]
      end
    end
    team_names_ids = Hash.new(0)

    @teams_collection.teams.each do |team|
      team_names_ids[team.team_id] = team.abbreviation
    end
    goals_allowed.each do |team|
      goals_allowed_averages = team[1].sum / team[1].length
        goals_allowed[team[0]] = goals_allowed_averages
      end
        team_id_max_goals = goals_allowed.min_by{ |k, v| v}
        team_names_ids[team_id_max_goals[0]]
  end

  def worst_defense
    goals_allowed = Hash.new(0)

    @games_collection.games.each do |game|
      if goals_allowed.has_key?(game.away_team_id)
        goals_allowed[game.away_team_id] << game.home_goals.to_i
      elsif !goals_allowed.has_key?(game.away_team_id)
        goals_allowed[game.away_team_id] = [game.home_goals.to_i]
      end
    end
    @games_collection.games.map do |game|
      if goals_allowed.has_key?(game.home_team_id)
        goals_allowed[game.home_team_id] << game.away_goals.to_i
      elsif !goals_allowed.has_key?(game.home_team_id)
        goals_allowed[game.home_team_id] = [game.away_goals.to_i]
      end
    end
    team_names_ids = Hash.new(0)

    @teams_collection.teams.each do |team|
      team_names_ids[team.team_id] = team.abbreviation
    end
    goals_allowed.each do |team|
      goals_allowed_averages = team[1].sum / team[1].length
        goals_allowed[team[0]] = goals_allowed_averages
      end
        team_id_max_goals = goals_allowed.max_by{ |k, v| v}
        team_names_ids[team_id_max_goals[0]]
  end

  def highest_scoring_visitor
    away_teams_goals = Hash.new(0)

    @games_collection.games.map do |game|
      away_teams_goals[game.away_team_id] += game.away_goals.to_i
    end
    team_names_ids = Hash.new(0)

    @teams_collection.teams.each do |team|
      team_names_ids[team.team_id] = team.abbreviation
    end
    away_team_max = away_teams_goals.max_by{ |k, v| v}
    team_names_ids[away_team_max[0]]
  end

  def highest_scoring_home_team
    home_teams_goals = Hash.new(0)

    @games_collection.games.map do |game|
      home_teams_goals[game.home_team_id] += game.home_goals.to_i
    end
    team_names_ids = Hash.new(0)

    @teams_collection.teams.each do |team|
      team_names_ids[team.team_id] = team.abbreviation
    end
    home_team_max = home_teams_goals.max_by{ |k, v| v}
    team_names_ids[home_team_max[0]]
  end
end
