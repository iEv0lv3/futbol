module Gatherable
  def games_by_team
    @games.collection.inject(Hash.new(0)) do |count, game|
      count[game[1].home_team_id] += 1
      count[game[1].away_team_id] += 1
      count
    end
  end

  def home_games_by_team
    @games.collection.inject(Hash.new(0)) do |count, game|
      count[game[1].home_team_id] += 1
      count
    end
  end

  def away_games_by_team
    @games.collection.inject(Hash.new(0)) do |count, game|
      count[game[1].away_team_id] += 1
      count
    end
  end

  def postseason_games_by_team
    @games.collection.inject(Hash.new(0)) do |count, game|
      if game[1].type == 'Postseason'
        count[game[1].home_team_id] += 1
        count[game[1].away_team_id] += 1
      end
      count
    end
  end

  def regular_season_games_by_team
    @games.collection.inject(Hash.new(0)) do |count, game|
      if game[1].type == 'Regular Season'
        count[game[1].home_team_id] += 1
        count[game[1].away_team_id] += 1
      end
      count
    end
  end

  def wins_by_team(collection)
    collection.inject(Hash.new(0)) do |wins, game|
      if game[1].home_goals.to_i > game[1].away_goals.to_i
        wins[game[1].home_team_id] += 1
      else
        wins[game[1].away_team_id] += 1
      end
      wins
    end
  end

  def season_wins_by_team(collection)
    collection.inject(Hash.new(0)) do |wins, season|
      if season.home_goals.to_i > season.away_goals.to_i
        wins[season.home_team_id] += 1
      end

      if season.away_goals.to_i > season.home_goals.to_i
        wins[season.away_team_id] += 1
      end
      wins
    end
  end

  # def game_win_count
  #   if type == 'Postseason'
  #     wins[type] = game_win_count
  #   elsif type == 'Regular Season'
  #     wins[type] = game_win_count
  #   end
  # end

  def home_wins_by_team
    @games.collection.inject(Hash.new(0)) do |wins, game|
      if game[1].home_goals.to_i > game[1].away_goals.to_i
        wins[game[1].home_team_id] += 1
      end
      wins
    end
  end

  def away_wins_by_team
    @games.collection.inject(Hash.new(0)) do |wins, game|
      if game[1].away_goals.to_i > game[1].home_goals.to_i
        wins[game[1].away_team_id] += 1
      end
      wins
    end
  end

  def goals_by_team
    @games.collection.inject(Hash.new(0)) do |scores, game|
      scores[game[1].home_team_id] += game[1].home_goals.to_i
      scores[game[1].away_team_id] += game[1].away_goals.to_i
      scores
    end
  end

  def home_goals_by_team
    @games.collection.inject(Hash.new(0)) do |scores, game|
      scores[game[1].home_team_id] += game[1].home_goals.to_i
      scores
    end
  end

  def away_goals_by_team
    @games.collection.inject(Hash.new(0)) do |scores, game|
      scores[game[1].away_team_id] += game[1].away_goals.to_i
      scores
    end
  end

  def goals_against_team
    @games.collection.inject(Hash.new(0)) do |scores, game|
      scores[game[1].home_team_id] += game[1].away_goals.to_i
      scores[game[1].away_team_id] += game[1].home_goals.to_i
      scores
    end
  end

  def get_team_name_by_id(team_id)
    @teams.collection[team_id].team_name
  end

  def team_hash(row, team_id)
    { team_id => { row[:season] => [] } }
  end

  def team_season_hash(row, collection_type, season_hash, team_id)
    season_hash[team_id] = { row[:season] => (season_hash[team_id][row[:season]] += [collection_type.new(row)]) }
    season_hash
  end

  def season_data_array(season_hash, team_id)
    season_hash[team_id].values.flatten!
  end

  def team_key(season_hash)
    season_hash.keys[0]
  end

  def season_key(season_hash, key)
    season_hash[key].keys[0]
  end

  def season_parse(key, season_key, season_data, hash)
    if hash.key?(key) && hash[key].key?(season_key)
      hash[key][season_key] << season_data
    elsif hash.key?(key) && !hash[key].key?(season_key)
      { hash[key] => hash[key][season_key] = season_data }
    elsif !hash.key?(key) && !hash.empty?
      hash[key] = { season_key => season_data }
    elsif hash.empty?
      hash = { key => { season_key => season_data } }
    end
    hash
  end

  def total_season_games_team_id(season_id)
    @seasons.teams.reduce({}) do |hash, team|
      hash[team.first] = team.last[season_id].size
      hash
    end
  end

  def total_season_wins_losses_team_id(season_id)
    @seasons.teams.reduce({}) do |hash, team|
      team_season = team[season_id]
      hash = win_or_loss(team.first, team_season)
      hash
    end
  end

  def team_goals_hash(season_id)
    @games.collection.values.reduce(Hash.new(0)) do |goals_hash, value|
      if value.season == season_id
        goals_hash[value.home_team_id] += value.home_goals.to_i
        goals_hash[value.away_team_id] += value.away_goals.to_i
      end

      goals_hash
    end
  end

  def team_shots_hash(season_id)
    @games.collection.values.reduce(Hash.new(0)) do |shots_hash, value|
      if value.season == season_id
        shots_hash[value.home_team_id] += value.home_shots.to_i
        shots_hash[value.away_team_id] += value.away_shots.to_i
      end

      shots_hash
    end
  end

  # def shoot_me(team_id)
  #   games_count = 0
  #   seasons.teams.reduce(Hash.new(0)) do |wins_hash, team|
  #     require "pry"; binding.pry
  #     if team[0] == team_id
  #       games_count += 1
  #       wins_hash[team[1].key] += team
  #     end
  #     wins_hash
  #   end
  # end

end
