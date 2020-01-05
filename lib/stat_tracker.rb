require 'csv'
require_relative 'collection'
require_relative 'league'
require_relative 'league_collection'
require_relative 'team'
require_relative 'team_collection'

class StatTracker
  attr_reader :team_collection, :league_collection

  def self.from_csv(locations)
    teams = locations[:teams]
    teams = locations[:league]

    StatTracker.new(teams, league)
  end

  def initialize(teams, league)
    @team_collection = TeamCollection.new(teams)
    @league_collection = LeagueCollection.new(league)
  end
end
