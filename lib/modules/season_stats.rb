require_relative './calculateable'
require_relative './gatherable'

module SeasonStats
  include Calculateable
  include Gatherable

  def most_accurate_team(season_id)
    get_team_name_by_id(divide_shots_by_goals(team_shots_hash(season_id), season_id).min_by { |_id, accuracy| accuracy}[0])
  end

  def least_accurate_team(season_id)
    get_team_name_by_id(divide_shots_by_goals(team_shots_hash(season_id), season_id).max_by { |_id, accuracy| accuracy}[0])
  end

  def best_season(team_id)
    shoot_me(team_id)
  end
end
