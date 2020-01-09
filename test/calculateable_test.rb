require_relative 'test_helper'
require './lib/modules/gatherable'
require './lib/modules/calculateable'
require './lib/tracker'
require './lib/stat_tracker'

class CalculateableTest < Minitest::Test
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

  def test_calculateable_exists
    calculateable = Calculateable

    assert_equal Calculateable, calculateable
  end

  def test_calculateable_team_average_goals
    test_hash = { '18' => 0.71 }

    assert_instance_of Hash, @stat_tracker.team_average_goals(test_hash)
  end

  def test_calculateable_can_return_team_win_percentage
    test_hash = { '18' => 0.71 }

    assert_instance_of Hash, @stat_tracker.team_win_percentage(test_hash)
  end

  def test_calculateable_can_return_season_coach_win_percent
    test_hash = { '18' => 0.71 }
    coach_hash = { 'John Tortorella' => 100 }

    assert_instance_of Hash, @stat_tracker.season_coach_win_percent(test_hash, '20132014')
    assert_instance_of Hash, @stat_tracker.season_coach_win_percent(coach_hash, '20132014')
  end

  def test_calculateable_can_return_team_away_average_wins
    test_hash = { '18' => 0.71 }

    assert_instance_of Hash, @stat_tracker.team_away_average_wins(test_hash)
  end

  def test_calculateable_can_return_combine_game_data
    assert_instance_of Hash, @stat_tracker.combine_game_data
    assert_equal 14_882, @stat_tracker.combine_game_data.size
  end

  def test_calculateable_league_win_percent_diff
    home_hash = { '18' => 0.71 }
    team_hash = { '18' => 0.71 }

    assert_instance_of Hash, @stat_tracker.league_win_percent_diff(home_hash, team_hash)
  end

  def test_calculateable_worst_team_help
    home_hash = { '18' => 0.71 }
    team_hash = { '18' => 0.81 }

    assert_instance_of Hash, @stat_tracker.worst_team_helper(home_hash, team_hash)
  end

  def test_calculateable_can_get_win_percent_diff
    regular = @stat_tracker.team_regular_season_record('20142015')
    post = @stat_tracker.team_postseason_record('20142015')

    assert_instance_of Hash, @stat_tracker.win_percentage_difference(regular, post)
  end

  def test_calculateable_can_get_win_percent_increase
    regular = @stat_tracker.team_regular_season_record('20142015')
    post = @stat_tracker.team_postseason_record('20142015')

    assert_instance_of Hash, @stat_tracker.win_percentage_increase(regular, post)
  end

  def test_calculateable_can_divide_shots_by_goals
    shots_hash = { '18' => 100 }

    assert_instance_of Hash, @stat_tracker.divide_shots_by_goals(shots_hash, '20142015')
  end
end
