require_relative 'league'
require 'csv'

class LeagueCollection < Collection

  def initialize(csv_file_path)
    super(csv_file_path, Game)
    super(csv_file_path, GameTeam)
  end
end

# League = {team_id: # GameTeam
#               {game_id: # UID
#               [:date_time, # Game
#                :hoa, # GameTeams
#                :home_team_id, # Game
#                :away_team_id, # Game

#                :goals, # GameTeams
#                :home_goals, # Game
#                :away_goals, # Game

#                :shots, # GameTeams
#                :tackles, # GameTeams
#                :giveaways, # GameTeams
#                :takeaways, # GameTeams

#                :result, # GameTeams
#                :settled_in, # GameTeams

#                :head_coach, # GameTeams
#                :season, # Game
#                :venue, # Game
#                :venue_link # Game
#               ]}}
