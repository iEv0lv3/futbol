require_relative 'test_helper'
require './lib/modules/gatherable'
require './lib/modules/calculateable'
require './lib/tracker'
require './lib/stat_tracker'

class GatherableTest < Minitest::Test
  include Gatherable
  include Calculateable

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

  def test_gatherable_exists
    gatherable = Gatherable

    assert_equal Gatherable, gatherable
  end

  def test_gatherable_can_return_games_by_team
    assert_instance_of Hash, @stat_tracker.games_by_team
    assert @stat_tracker.games_by_team.has_key?("3")
    assert @stat_tracker.games_by_team.has_key?("18")
  end

  def test_gatherable_can_return_home_games_by_team
    assert_instance_of Hash, @stat_tracker.home_games_by_team
    assert @stat_tracker.home_games_by_team.has_key?("3")
    assert @stat_tracker.home_games_by_team.has_key?("18")
  end

  def test_gatherable_can_return_away_games_by_team
    assert_instance_of Hash, @stat_tracker.away_games_by_team
    assert @stat_tracker.away_games_by_team.has_key?("3")
    assert @stat_tracker.away_games_by_team.has_key?("18")
  end

  def test_gatherable_can_return_wins_by_team
    assert_instance_of Hash, @stat_tracker.wins_by_team
  end

  def test_gatherable_can_return_games_by_season
    assert_instance_of Hash, @stat_tracker.games_by_season('20132014')
    assert @stat_tracker.games_by_season('20132014').has_key?("3")
    assert @stat_tracker.games_by_season('20132014').has_key?("18")
  end

  def test_gatherable_can_return_season_games_by_coach
    assert_instance_of Hash, @stat_tracker.season_games_by_coach('20132014')
    assert @stat_tracker.season_games_by_coach('20132014').has_key?("Darryl Sutter")
    assert @stat_tracker.season_games_by_coach('20132014').has_key?("Mike Sullivan")
  end

  def test_gatherable_can_return_season_wins_by_coach
    assert_instance_of Hash, @stat_tracker.season_wins_by_coach('20132014')
    assert @stat_tracker.season_wins_by_coach('20132014').has_key?("Darryl Sutter")
    assert @stat_tracker.season_wins_by_coach('20132014').has_key?("Mike Sullivan")
  end

  def test_gatherable_can_return_home_wins_by_team
    assert_instance_of Hash, @stat_tracker.home_wins_by_team
    assert @stat_tracker.home_wins_by_team.has_key?("3")
    assert @stat_tracker.home_wins_by_team.has_key?("18")
  end

  def test_gatherable_can_return_away_wins_by_team
    assert_instance_of Hash, @stat_tracker.away_wins_by_team
    assert @stat_tracker.away_wins_by_team.has_key?("3")
    assert @stat_tracker.away_wins_by_team.has_key?("18")
  end

  def test_gatherable_can_return_goals_by_team
    assert_instance_of Hash, @stat_tracker.goals_by_team
    assert @stat_tracker.goals_by_team.has_key?("3")
    assert @stat_tracker.goals_by_team.has_key?("18")
  end

  def test_gatherable_can_return_home_goals_by_team
    assert_instance_of Hash, @stat_tracker.home_goals_by_team
    assert @stat_tracker.home_goals_by_team.has_key?("3")
    assert @stat_tracker.home_goals_by_team.has_key?("18")
  end

  def test_gatherable_can_return_away_goals_by_team
    assert_instance_of Hash, @stat_tracker.away_goals_by_team
    assert @stat_tracker.away_goals_by_team.has_key?("3")
    assert @stat_tracker.away_goals_by_team.has_key?("18")
  end

  def test_gatherable_can_return_goals_against_team
    assert_instance_of Hash, @stat_tracker.goals_against_team
    assert @stat_tracker.goals_against_team.has_key?("3")
    assert @stat_tracker.goals_against_team.has_key?("18")
  end

  def test_gatherable_can_return_get_team_name_by_id
    assert_instance_of String, @stat_tracker.get_team_name_by_id('3')
    assert_equal "Houston Dynamo", @stat_tracker.get_team_name_by_id('3')
    assert_instance_of String, @stat_tracker.get_team_name_by_id('18')
    assert_equal "Minnesota United FC", @stat_tracker.get_team_name_by_id('18')
  end

  def test_gatherable_can_create_a_team_goals_hash
    assert_instance_of Hash, @stat_tracker.team_goals_hash('20142015')
  end

  def test_gatherable_can_create_a_team_shots_hash
    assert_instance_of Hash, @stat_tracker.team_shots_hash('20142015')
  end
end
