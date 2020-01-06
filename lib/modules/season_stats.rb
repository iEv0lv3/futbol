require_relative './calculateable'
require_relative './gatherable'

module SeasonStats
  include Calculateable
  include Gatherable

  # def winningest_coach(season_id)
  #   hash = 0
  #   @games.collection.values.map do |game|
  #     require "pry"; binding.pry
  #     if game.season == season_id
  #       hash[game.away_team_id] += game.away_goals.to_i
  #     end
  #   end
  # end

  def most_accurate_team(season_id)
    games.collection.values.reduce({}) do |game_id_hash, value|
      game_id_hash[value.game_id] = value.home_team_id
    end
  end

end
