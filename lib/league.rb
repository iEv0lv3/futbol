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

  def initialize(source, row)
    @team_id = source[row][:team_id] # GameTeams + Main Key

    @game_id = source[row][:game_id] # GameTeams link to Game data + Value-Hash Key
    @game_id = source[row][:game_id] # Game

    @date_time = source[row][:date_time] # Game
    @hoa = source[row][:hoa] # GameTeams
    @home_team_id = source[row][:home_team_id] # Game
    @away_team_id = source[row][:away_team_id] # Game

    @goals = source[row][:goals] # GameTeams
    @home_goals = source[row][:home_goals] # Game
    @away_goals = source[row][:away_goals] # Game

    @shots = source[row][:shots] # GameTeams
    @tackles = source[row][:tackles] # GameTeams
    @giveaways = source[row][:giveaways] # GameTeams
    @takeaways = source[row][:takeaways] # GameTeams

    @result = source[row][:result] # GameTeams
    @settled_in = source[row][:settled_in] # GameTeams

    @head_coach = source[row][:head_coach] # GameTeams
    @season = source[row][:season] # Game
    @type = source[row][:type] # Game
    @venue = source[row][:venue] # Game
    @venue_link = source[row][:venue_link] # Game
  end
end

# game_id was left off the GameTeam files entirely!!!
# Synthesize Game + GameTeam into a single data set called League linked by game_id as UID
#  ARG: League is the highest abstraction w/ Teams being the second tier.
#    Leagues are made of Teams not Games or Seasons
#    Games, Seasons, etc. all belong to Teams.
#  ARG: All current methods are satisfied with this combined data set.
#  ARG: We can run the Game & GameTeams CSV once to create the League data set.
