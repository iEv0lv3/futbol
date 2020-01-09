module Summary
  def seasonal_summary(team_id)
    reg_season = season_summary_regular_season_record(team_id)

    regular_summary = reg_season.inject(Hash.new(Hash.new(0.0))) do |hash, record|
      hash[record[0]] = {
        regular_season: {
          win_percentage: record[1][:win_percentage],
          total_goals_scored: record[1][:goals],
          total_goals_against: record[1][:goals_against],
          average_goals_scored: record[1][:goals_scored_percentage],
          average_goals_against: record[1][:goals_against_percentage]
        }
      }
      hash
    end

    post_season = season_summary_postseason_record(team_id)
    post_summary = post_season.inject(Hash.new(Hash.new(0.0))) do |hash, record|
      hash[record[0]] = {
        postseason: {
          win_percentage: record[1][:win_percentage],
          total_goals_scored: record[1][:goals],
          total_goals_against: record[1][:goals_against],
          average_goals_scored: record[1][:goals_scored_percentage],
          average_goals_against: record[1][:goals_against_percentage]
        }
      }
      hash
    end

    post_summary.merge(regular_summary) { |_season, post, reg| post.merge(reg) }
  end

  def season_summary_win_percentage(hash, season_id)
    total_games = (hash[season_id][:win] + hash[season_id][:loss] + hash[season_id][:draw])
    wins = hash[season_id][:win]
    percentage = ((wins.to_f / total_games)).round(2)

    if percentage.nan?
      hash[season_id][:win_percentage] = 0.0
    else
      hash[season_id][:win_percentage] = percentage
    end
    hash
  end

  def season_summary_goals_percentage(hash, season_id)
    total_games = (hash[season_id][:win] + hash[season_id][:loss] + hash[season_id][:draw])
    goals = hash[season_id][:goals]
    percentage = ((goals.to_f / total_games)).round(2)

    if percentage.nan?
      hash[season_id][:goals_scored_percentage] = 0.0
    else
      (hash[season_id][:goals_scored_percentage] = percentage)
    end
    hash
  end

  def season_summary_goals_against_percentage(hash, season_id)
    total_games = (hash[season_id][:win] + hash[season_id][:loss] + hash[season_id][:draw])
    goals = hash[season_id][:goals_against]
    percentage = ((goals.to_f / total_games)).round(2)

    if percentage.nan?
      hash[season_id][:goals_against_percentage] = 0.0
    else
      (hash[season_id][:goals_against_percentage] = percentage)
    end
    hash
  end

  def season_summary_regular_season_record(team_id)
    @seasons.teams[team_id].reduce({}) do |hash, season|
      next(hash) if season[1].nil?
      season_id = season[0]
      team_season = season[1].flatten
      hash[season[0]] = team_win_lose_draw_regular_season(team_id, team_season)
      season_summary_win_percentage(hash, season_id)
      season_summary_goals_percentage(hash, season_id)
      season_summary_goals_against_percentage(hash, season_id)
      hash
    end
  end

  def season_summary_postseason_record(team_id)
    @seasons.teams[team_id].reduce({}) do |hash, season|
      next(hash) if season[1].nil?
      season_id = season[0]
      team_season = season[1].flatten
      hash[season[0]] = team_win_lose_draw_postseason(team_id, team_season)
      season_summary_win_percentage(hash, season_id)
      season_summary_goals_percentage(hash, season_id)
      season_summary_goals_against_percentage(hash, season_id)
      hash
    end
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
        record[:goals_against] += game.away_goals.to_i if team_id == game.home_team_id
        record[:goals_against] += game.home_goals.to_i if team_id == game.away_team_id
      end
      hash = record
      hash
    end
  end

  def team_win_lose_draw_postseason(team_id, team_season)
    record = { win: 0, loss: 0, draw: 0, postseason_games: 0, win_percentage: 0.0, goals: 0, goals_against: 0 }
    team_season.reduce({}) do |hash, game|
      if team_id == game.home_team_id && (game.home_goals > game.away_goals) && game.type == 'Postseason'
        record[:win] += 1
        record[:postseason_games] += 1
        record[:goals] += game.home_goals.to_i
        record[:goals_against] += game.away_goals.to_i
      elsif team_id == game.home_team_id && (game.home_goals < game.away_goals) && game.type == 'Postseason'
        record[:loss] += 1
        record[:postseason_games] += 1
        record[:goals] += game.home_goals.to_i
        record[:goals_against] += game.away_goals.to_i
      elsif team_id == game.away_team_id && (game.away_goals > game.home_goals) && game.type == 'Postseason'
        record[:win] += 1
        record[:postseason_games] += 1
        record[:goals] += game.away_goals.to_i
        record[:goals_against] += game.home_goals.to_i
      elsif team_id == game.away_team_id && (game.away_goals < game.home_goals) && game.type == 'Postseason'
        record[:loss] += 1
        record[:postseason_games] += 1
        record[:goals] += game.away_goals.to_i
        record[:goals_against] += game.home_goals.to_i
      elsif game.home_goals == game.away_goals && game.type == 'Postseason'
        record[:draw] += 1
        record[:postseason_games] += 1
        record[:goals] += game.away_goals.to_i if team_id == game.away_team_id
        record[:goals] += game.home_goals.to_i if team_id == game.home_team_id
        record[:goals_against] += game.away_goals.to_i if team_id == game.home_team_id
        record[:goals_against] += game.home_goals.to_i if team_id == game.away_team_id
      end
      hash = record
      hash
    end
  end
end
