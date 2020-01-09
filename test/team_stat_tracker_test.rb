require_relative './test_helper'
require 'csv'
require './lib/tracker'
require './lib/stat_tracker'
require './lib/game'
require './lib/team'
require './lib/game_teams'
require './lib/season'
require './lib/collection'
require './lib/game_collection'
require './lib/team_collection'
require './lib/game_teams_collection'
require './lib/season_collection'

class TeamStatTrackerTest < Minitest::Test

def setup
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    @stat_tracker = Tracker.from_csv(locations)
  end

  def test_best_season
    assert_equal '20132014', @stat_tracker.best_season('6')
  end

  def test_worst_season
    assert_equal '20142015', @stat_tracker.worst_season('6')
  end
end
