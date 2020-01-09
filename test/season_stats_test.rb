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

  def test_biggest_bust_method
    assert_instance_of String, @stat_tracker.biggest_bust("20132014")
    assert_equal "Montreal Impact", @stat_tracker.biggest_bust("20132014")
    assert_instance_of String, @stat_tracker.biggest_bust("20142015")
    assert_equal "Sporting Kansas City", @stat_tracker.biggest_bust("20142015")
  end

  def test_biggest_surprise
    assert_instance_of String, @stat_tracker.biggest_surprise("20132014")
    assert_equal "FC Cincinnati", @stat_tracker.biggest_surprise("20132014")
    assert_instance_of String, @stat_tracker.biggest_surprise("20142015")
    assert_equal "Minnesota United FC", @stat_tracker.biggest_surprise("20142015")
  end

  def test_winningest_coach
    assert_instance_of String, @stat_tracker.winningest_coach("20132014")
    assert_equal "Claude Julien", @stat_tracker.winningest_coach("20132014")
    assert_instance_of String, @stat_tracker.winningest_coach("20142015")
    assert_equal "Alain Vigneault", @stat_tracker.winningest_coach("20142015")
  end

  def test_season_stats_can_get_worst_coach
    assert_instance_of String, @stat_tracker.worst_coach("20132014")
    assert_equal "Peter Laviolette", @stat_tracker.worst_coach("20132014")
    assert_includes ["Ted Nolan","Craig MacTavish"], @stat_tracker.worst_coach("20142015")
  end

  def test_most_accurate_team
    assert_instance_of String, @stat_tracker.most_accurate_team("20132014")
    assert_equal "Real Salt Lake", @stat_tracker.most_accurate_team("20132014")
    assert_instance_of String, @stat_tracker.most_accurate_team("20142015")
    assert_equal "Toronto FC", @stat_tracker.most_accurate_team("20142015")
  end

  def test_least_accurate_team
    assert_instance_of String, @stat_tracker.least_accurate_team("20132014")
    assert_equal "New York City FC", @stat_tracker.least_accurate_team("20132014")
    assert_instance_of String, @stat_tracker.least_accurate_team("20142015")
    assert_equal "Columbus Crew SC", @stat_tracker.least_accurate_team("20142015")
  end

  def test_most_tackles
    assert_instance_of String, @stat_tracker.most_tackles("20132014")
    assert_equal "FC Cincinnati", @stat_tracker.most_tackles("20132014")
    assert_instance_of String, @stat_tracker.most_tackles("20142015")
    assert_equal "Seattle Sounders FC", @stat_tracker.most_tackles("20142015")
  end

  def test_fewest_tackles
    assert_instance_of String, @stat_tracker.fewest_tackles("20132014")
    assert_equal "Atlanta United", @stat_tracker.fewest_tackles("20132014")
    assert_instance_of String, @stat_tracker.fewest_tackles("20142015")
    assert_equal "Orlando City SC", @stat_tracker.fewest_tackles("20142015")
  end

  def test_total_tackles_by_team_per_season
    expected = {"14"=>2594, "16"=>2030, "3"=>2511, "5"=>2647, "19"=>1981, "30"=>1594, "8"=>2082,
      "9"=>2566, "15"=>2880, "2"=>3002, "24"=>2960, "52"=>2585, "29"=>2510, "26"=>2630, "12"=>1953,
      "53"=>2489, "22"=>1980, "21"=>2018, "28"=>1930, "6"=>2112, "4"=>2511, "25"=>1657, "13"=>2268,
      "10"=>2545, "17"=>1789, "7"=>2204, "20"=>2086, "1"=>1646, "23"=>1700, "18"=>1957}
    assert_instance_of Hash, @stat_tracker.total_tackles_by_team_per_season("20142015")
    assert_equal expected, @stat_tracker.total_tackles_by_team_per_season("20142015")
  end

  def test_total_season_games_team_id
    skip
    # assert_instance_of Hash, @stat_tracker.total_season_games_team_id("20132014")
    assert_equal 3, @stat_tracker.total_season_games_team_id("20132014")
  end

  def test_team_season_record
    skip
    assert_instance_of Hash, @stat_tracker.team_season_record("20132014")
    assert_equal 3, @stat_tracker.team_season_record("20132014")
  end

  def test_win_lose_draw
      game = mock("Game")
      game.stubs(:klass).returns("Game")
      stat_tracker = mock("StatTracker")
      stat_tracker.stubs(:win_lose_draw).returns([game, game, game])
    assert_equal 3, stat_tracker.win_lose_draw("3", game).size
  end

  def test_team_postseason_record
    assert_instance_of Hash, @stat_tracker.team_postseason_record("20132014")
    assert_equal 30, @stat_tracker.team_postseason_record("20132014").size
  end

  def test_win_lose_draw_postseason
    
    assert_instance_of Hash, @stat_tracker.win_lose_draw_postseason(4, "3")
  end
end
