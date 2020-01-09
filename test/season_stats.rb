require_relative './calculateable'
require_relative './gatherable'
include './season_stats'

module SeasonStats
  include Calculateable
  include Gatherable
  include SeasonStats

  def most_accurate_team(season_id)
    get_team_name_by_id(divide_shots_by_goals(team_shots_hash(season_id), season_id).min_by { |_id, accuracy| accuracy}[0])
  end

  def least_accurate_team(season_id)
    get_team_name_by_id(divide_shots_by_goals(team_shots_hash(season_id), season_id).max_by { |_id, accuracy| accuracy}[0])
  end

  def most_tackles(season_id)
    team_id = total_tackles_by_team_per_season(season_id).max_by { |_team, tackles| tackles }
    get_team_name_by_id(team_id.first)
  end

  def fewest_tackles(season_id)
    team_id = total_tackles_by_team_per_season(season_id).min_by { |_team, tackles| tackles }
    get_team_name_by_id(team_id.first)
  end

  def winningest_coach(season_id)
    season_coach_win_percent(season_wins_by_coach(season_id), season_id).compact.max_by { |_id, avg| avg }[0]
  end

  def worst_coach(season_id)
    season_coach_win_percent(season_wins_by_coach(season_id), season_id).compact.min_by { |_id, avg| avg }[0]
  end

  def biggest_bust(season_id)
    regular = team_regular_season_record(season_id)
    post = team_postseason_record(season_id)
    biggest_difference = win_percentage_difference(regular, post)
    team_id = biggest_difference.max_by { |_k, v| v }[0]
    get_team_name_by_id(team_id)
  end

  def biggest_surprise(season_id)
    regular = team_regular_season_record(season_id)
    post = team_postseason_record(season_id)
    biggest_increase = win_percentage_increase(regular, post)
    team_id = biggest_increase.max_by { |_k, v| v }[0]
    get_team_name_by_id(team_id)
  end
end
