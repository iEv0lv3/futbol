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

class StatTrackerTest < Minitest::Test
  def setup
    game_path = './test/fixtures/games_truncated.csv'
    team_path = './data/teams.csv'
    game_team_path = './test/fixtures/game_teams_truncated.csv'
    games = GameCollection.new(game_path)
    teams = TeamCollection.new(team_path)
    game_team = GameTeamCollection.new(game_team_path)
    @new_tracker = StatTracker.new(games, teams)
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

  def test_stat_tracker_exists
    stat_tracker = mock('StatTracker')
    stat_tracker.stubs(:klass).returns('StatTracker')

    assert_equal 'StatTracker', stat_tracker.klass
  end

  def test_that_collections_are_the_correct_class_type
    stat_tracker = mock('StatTracker')
    stat_tracker.stubs(:klass).returns('KlassType')

    assert_equal 'KlassType', stat_tracker.klass

    stat_tracker.stubs(:game_collection).returns('GameCollection')
    assert_equal 'GameCollection', stat_tracker.game_collection

    stat_tracker.stubs(:team_collection).returns('TeamCollection')
    assert_equal 'TeamCollection', stat_tracker.team_collection

    stat_tracker.stubs(:team_season_collection).returns('TeamSeasonCollection')
    assert_equal 'TeamSeasonCollection', stat_tracker.team_season_collection

    stat_tracker.stubs(:game_teams_collection).returns('GameTeamsCollection')
    assert_equal 'GameTeamsCollection', stat_tracker.game_teams_collection
  end

  def test_stat_tracker_average_goals_per_game
    assert_instance_of Float, @stat_tracker.average_goals_per_game
    assert_equal 4.22, @stat_tracker.average_goals_per_game
  end

  def test_stat_tracker_average_goals_by_season
    average_hash = {
      '20122013' => 4.12,
      '20132014' => 4.19,
      '20142015' => 4.14,
      '20152016' => 4.16,
      '20162017' => 4.23,
      '20172018' => 4.44
    }

    assert_equal average_hash, @stat_tracker.average_goals_by_season
  end

  def test_highest_total_score
    assert_instance_of Integer, @stat_tracker.highest_total_score
    assert_equal 11, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    assert_instance_of Integer, @stat_tracker.lowest_total_score
    assert_equal 0, @stat_tracker.lowest_total_score
  end

  def test_biggest_blowout_margin
    stat_tracker = mock('StatTracker')
    stat_tracker.stubs(:biggest_blowout).returns(8)
    assert_equal 8, stat_tracker.biggest_blowout
  end

  def test_count_of_games_by_season
    stat_tracker = mock('StatTracker')
    stat_tracker.stubs(:count_of_games_by_season).returns(
      '20122013' => 806,
      '20132014' => 1323,
      '20142015' => 1319,
      '20152016' => 1321,
      '20162017' => 1317,
      '20172018' => 1355
    )
    assert_equal 1355, stat_tracker.count_of_games_by_season['20172018']
  end

  def test_percentage_ties_method
    assert_instance_of Float, @stat_tracker.percentage_ties
    assert_equal 0.2, @stat_tracker.percentage_ties
  end

  def test_percentage_home_wins
    team_1_home = @stat_tracker.percentage_home_wins
    assert_instance_of Float, team_1_home
    assert_equal 0.44, team_1_home
  end

  def test_percentage_visitor_wins
    team_1_visitor = @stat_tracker.percentage_visitor_wins
    assert_instance_of Float, team_1_visitor
    assert_equal 0.36, team_1_visitor
  end

  def test_stat_tracker_gets_count_of_teams
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

  def test_count_of_teams
    assert_instance_of Integer, @new_tracker.count_of_teams
    assert_equal 32, @new_tracker.count_of_teams
  end

  def test_best_offense
    assert_instance_of String, @new_tracker.best_offense
    assert_equal "NE", @new_tracker.best_offense
  end

  def test_worst_offense
    assert_instance_of String, @new_tracker.worst_offense
    assert_equal "ORL", @new_tracker.worst_offense
  end

  def test_best_defense
    assert_instance_of String, @new_tracker.best_defense
    assert_equal "SKC", @new_tracker.best_defense
  end

  def test_worst_defense
    assert_instance_of String, @new_tracker.worst_defense
    assert_equal "NE", @new_tracker.worst_defense
  end

  def test_highest_scoring_visitor
    assert_instance_of String, @new_tracker.highest_scoring_visitor
    assert_equal "RSL", @new_tracker.highest_scoring_visitor
  end

  def test_highest_scoring_home_team
    assert_instance_of String, @new_tracker.highest_scoring_home_team
    assert_equal "NE", @new_tracker.highest_scoring_home_team
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

  def test_stat_tracker_can_get_most_tackles
    assert_instance_of String, @stat_tracker.most_tackles('20172018')
    assert_equal "Minnesota United FC", @stat_tracker.most_tackles('20172018')

    assert_instance_of String, @stat_tracker.most_tackles('20132014')
    assert_equal "Sporting Kansas City", @stat_tracker.most_tackles('20132014')

    assert_instance_of String, @stat_tracker.most_tackles('20152016')
    assert_equal "Vancouver Whitecaps FC", @stat_tracker.most_tackles('20152016')

  end

  def test_stat_tracker_can_get_fewest_tackles
    assert_instance_of String, @stat_tracker.fewest_tackles('20172018')
    assert_equal "New England Revolution", @stat_tracker.fewest_tackles('20172018')

    assert_instance_of String, @stat_tracker.fewest_tackles('20132014')
    assert_equal "Montreal Impact", @stat_tracker.fewest_tackles('20132014')

    assert_instance_of String, @stat_tracker.fewest_tackles('20152016')
    assert_equal "Philadelphia Union", @stat_tracker.fewest_tackles('20152016')
  end
end
