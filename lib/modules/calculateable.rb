require_relative 'gatherable'

module Calculateable
  include Gatherable

  def team_average_goals(goals_hash)
    average_goals = {}
    goals_hash.each do |team, tot_score|
      average_goals[team] = (tot_score.to_f / games_by_team[team]).round(2)
    end

    average_goals
  end

  def team_win_percentage(wins_hash)
    average_wins = {}
    wins_hash.each do |team, tot_wins|
      average_wins[team] = (tot_wins.to_f / games_by_team[team])
    end

    average_wins
  end

  def season_coach_win_percent(wins_hash, season_id)
    average_wins = {}
    wins_hash.each do |coach, tot_wins|
      if season_games_by_coach(season_id)[coach] == 0
        average_wins[coach] = nil
      else
        average_wins[coach] = (tot_wins.to_f / season_games_by_coach(season_id)[coach])
      end
    end
    average_wins
  end

  def team_postseason_win_percent(wins_hash)
    average_wins = {}
    wins_hash.each do |team, tot_wins|
      average_wins[team] = (tot_wins.to_f / postseason_games_by_team[team])
    end
    average_wins
  end

  def team_home_average_wins(wins_hash)
    average_wins = {}
    wins_hash.each do |team, tot_wins|
      average_wins[team] = (tot_wins.to_f / home_games_by_team[team])
    end
    average_wins
  end

  def team_away_average_wins(wins_hash)
    average_wins = {}
    wins_hash.each do |team, tot_wins|
      average_wins[team] = (tot_wins.to_f / away_games_by_team[team])
    end
    average_wins
  end

  def team_total_seasons(team_id)
    @team_season_collection.collection[team_id].size
  end

  def team_season_keys(team_id)
    { team_id => @team_season_collection.collection[team_id].keys }
  end

  def combine_game_data
    @game_teams.collection.each do |game|
      team_game = @games.collection[game[1].game_id]
      if game[1].team_id == team_game.home_team_id
        team_game.home_coach = game[1].head_coach
        team_game.home_shots = game[1].shots
        team_game.home_tackles = game[1].tackles
      elsif game[1].team_id == team_game.away_team_id
        team_game.away_coach = game[1].head_coach
        team_game.away_shots = game[1].shots
        team_game.away_tackles = game[1].tackles
      end
    end
  end

  def divide_shots_by_goals(shots_hash, season_id)
    team_accuracy = {}
    shots_hash.each do |team_id, tot_shots|
      team_accuracy[team_id] = tot_shots.to_f / team_goals_hash(season_id)[team_id]
    end

    team_accuracy
  end
  
  def create_season
    @games.collection.reduce(Hash.new({})) do |hash, game|
      h_team_id = game[1].home_team_id
      a_team_id = game[1].away_team_id
      season = game[1].season
      hash = { h_team_id => { season => [] } } if hash.empty?
      hash = { h_team_id => { season => [] } } if hash[h_team_id].nil?
      hash = { h_team_id => { season => [] } } if hash[h_team_id][season].nil?
      hash[h_team_id] = { season => (hash[h_team_id][season] += [game[1]]) }
      # season_hash[team_id] = { row[:season] => (season_hash[team_id][row[:season]] += [collection_type.new(row)]) }
      hash
    end
  end

  def league_win_percent_diff(home, away)
    home.inject(Hash.new(0)) do |hash, team|
      hash[team[0]] = (team[1] - away[team[0]]).abs.round(2)
      hash 
    end
  end

  def win_percentage_difference(regular, post)
    post.reduce(Hash.new(0)) do |hash, team|
      next(hash) if team[1][:win_percentage].nan?

      hash[team[0]] = (team[1][:win_percentage] - regular[team[0]][:win_percentage]).abs.round(2)
      hash
    end
  end

  def win_percentage_increase(regular, post)
    post.reduce(Hash.new(0)) do |hash, team|
      next(hash) if team[1][:win_percentage].nan?

      hash[team[0]] = (team[1][:win_percentage] - regular[team[0]][:win_percentage]).round(2)
      hash
    end
  end

  def worst_team_helper(home, away)
    home.inject(Hash.new(0)) do |hash, team|
      if away[team[0]] > team[1]
        hash[team[0]] = (team[1] - away[team[0]]).abs.round(2)
      end
      hash
    end
  end
end
