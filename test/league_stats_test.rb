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

class LeagueStatsTest < Minitest::Test
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

  def test_count_of_teams
    assert_instance_of Integer, @stat_tracker.count_of_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end

  def test_stat_tracker_can_get_best_offense
    assert_instance_of String, @stat_tracker.best_offense
    assert_equal 'Reign FC', @stat_tracker.best_offense
  end

  def test_stat_tracker_can_get_worst_offense
    assert_instance_of String, @stat_tracker.worst_offense
    assert_equal 'Utah Royals FC', @stat_tracker.worst_offense
  end
  
  def test_stat_tracker_can_get_best_defense
    assert_instance_of String, @stat_tracker.best_defense
    assert_equal 'FC Cincinnati', @stat_tracker.best_defense
  end

  def test_stat_tracker_can_get_worst_defense
    assert_instance_of String, @stat_tracker.worst_defense
    assert_equal 'Columbus Crew SC', @stat_tracker.worst_defense
  end

  def test_stat_tracker_can_get_highest_scoring_visitor
    assert_instance_of String,  @stat_tracker.highest_scoring_visitor
    assert_equal 'FC Dallas', @stat_tracker.highest_scoring_visitor
  end

  def test_stat_tracker_can_get_highest_scoring_home
    assert_instance_of String, @stat_tracker.highest_scoring_home_team
    assert_equal 'Reign FC', @stat_tracker.highest_scoring_home_team
  end

  def test_stat_tracker_can_get_lowest_scoring_visitor
    assert_instance_of String, @stat_tracker.lowest_scoring_visitor
    assert_equal 'San Jose Earthquakes', @stat_tracker.lowest_scoring_visitor
  end

  def test_stat_tracker_can_get_lowest_scoring_home
    assert_instance_of String, @stat_tracker.lowest_scoring_home_team
    assert_equal 'Utah Royals FC', @stat_tracker.lowest_scoring_home_team
  end

  def test_stat_tracker_can_get_winningest_team
    assert_instance_of String, @stat_tracker.winningest_team
    assert_equal 'Reign FC', @stat_tracker.winningest_team
  end

  def test_stat_tracker_can_get_best_fans
    assert_instance_of String, @stat_tracker.best_fans
    assert_equal 'San Jose Earthquakes', @stat_tracker.best_fans
  end

  def test_stat_tracker_can_get_worst_fans
    assert_equal ['Houston Dynamo', 'Utah Royals FC'], @stat_tracker.worst_fans
  end
end