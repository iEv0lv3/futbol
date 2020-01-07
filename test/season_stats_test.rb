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

class SeasonStatsTest < Minitest::Test
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

  def test_most_accurate_team
    assert_equal 'Real Salt Lake', @stat_tracker.most_accurate_team('20132014')
    assert_equal 'Toronto FC', @stat_tracker.most_accurate_team('20142015')
  end

  def test_least_accurate_team
    assert_equal 'New York City FC', @stat_tracker.least_accurate_team('20132014')
    assert_equal 'Columbus Crew SC', @stat_tracker.least_accurate_team('20142015')
  end

  def test_biggest_bust_method
    assert_equal 'Montreal Impact', @stat_tracker.biggest_bust('20132014')
    assert_equal 'Sporting Kansas City', @stat_tracker.biggest_bust('20142015')
  end

  def test_season_stats_can_get_winningest_coach
    assert_equal 'Claude Julien', @stat_tracker.winningest_coach('20132014')
    assert_equal 'Alain Vigneault', @stat_tracker.winningest_coach('20142015')
  end

  def test_season_stats_can_get_worst_coach
    assert_equal 'Peter Laviolette', @stat_tracker.worst_coach('20132014')
    assert_includes ['Ted Nolan','Craig MacTavish'], @stat_tracker.worst_coach('20142015')
  end

  def test_best_season_by_team_id
    assert_equal '20132014', @stat_tracker.best_season("6")
  end

  def test_worst_season_by_team_id
    skip
    assert_equal '20142015', @stat_tracker.worst_season("6")
  end
end
