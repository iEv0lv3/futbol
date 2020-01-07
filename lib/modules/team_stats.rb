require_relative 'calculateable'
require_relative 'gatherable'
require_relative 'season_stats'

module TeamStats
  include Gatherable
  include Calculateable
  include SeasonStats

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

  def team_season_wins_hash(team_id)
    percentage_seasons = Hash.new(0)
    @seasons.teams[team_id].each do |season|
      season_key = season[0]
      team_season = season[1].flatten!
      stats = win_lose_draw_regular_season(team_id, team_season)
      final_percentage = team_season_win_percentage(stats, team_id)
      percentage_seasons[season_key] = final_percentage[:win_percentage]
    end
    
    percentage_seasons
  end

  def team_season_win_percentage(hash, team_id)
    total_games = (hash[:win] + hash[:loss] + hash[:draw])
    wins = hash[:win]
    percentage = ((wins.to_f / total_games) * 100).round(2)
    hash[:win_percentage] = percentage
    hash
  end
end
