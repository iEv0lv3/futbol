class League
  attr_reader :team_id,
    :game_id,
    :date_time,
    :hoa,
    :home_team_id,
    :away_team_id,
    :goals,
    :home_goals,
    :away_goals,
    :shots,
    :tackles,
    :giveaways,
    :takeaways,
    :result,
    :settled_in,
    :head_coach,
    :season,
    :type,
    :venue,
    :venue_link

  def initialize(row)
    @team_id = row[:team_id] # GameTeams + Main Key

    @game_id = row[:game_id] # GameTeams link to Game data + Value-Hash Key
    @game_id = row[:game_id] # Game

    @date_time = row[:date_time] # Game
    @hoa = row[:hoa] # GameTeams
    @home_team_id = row[:home_team_id] # Game
    @away_team_id = row[:away_team_id] # Game

    @goals = row[:goals] # GameTeams
    @home_goals = row[:home_goals] # Game
    @away_goals = row[:away_goals] # Game

    @shots = row[:shots] # GameTeams
    @tackles = row[:tackles] # GameTeams
    @giveaways = row[:giveaways] # GameTeams
    @takeaways = row[:takeaways] # GameTeams

    @result = row[:result] # GameTeams
    @settled_in = row[:settled_in] # GameTeams

    @head_coach = row[:head_coach] # GameTeams
    @season = row[:season] # Game
    @type = row[:type] # Game
    @venue = row[:venue] # Game
    @venue_link = row[:venue_link] # Game
  end
end

# game_id was left off the GameTeam files entirely!!!
# Synthesize Game + GameTeam into a single data set called League linked by game_id as UID
#  ARG: League is the highest abstraction w/ Teams being the second tier.
#    Leagues are made of Teams not Games or Seasons
#    Games, Seasons, etc. all belong to Teams.
#  ARG: All current methods are satisfied with this combined data set.
#  ARG: We can run the Game & GameTeams CSV once to create the League data set.
