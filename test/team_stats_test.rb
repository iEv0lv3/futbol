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

class TeamStatsTest < Minitest::Test
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

  def test_team_stats_can_get_favorite_opponent
    assert_equal 'DC United', @stat_tracker.favorite_opponent('18')
  end

  def test_team_stats_can_get_rivals
    assert_includes ['Houston Dash', 'LA Galaxy'], @stat_tracker.rival('18')
  end

  def test_head_to_head
    expected1 = {
      'Atlanta United' => 0.5,
      'Chicago Fire' => 0.3,
      'FC Cincinnati' => 0.39,
      'DC United' => 0.8,
      'FC Dallas' => 0.4,
      'Houston Dynamo' => 0.4,
      'Sporting Kansas City' => 0.25,
      'LA Galaxy' => 0.29,
      'Los Angeles FC' => 0.44,
      'Montreal Impact' => 0.33,
      'New England Revolution' => 0.47,
      'New York City FC' => 0.6,
      'New York Red Bulls' => 0.4,
      'Orlando City SC' => 0.37,
      'Portland Timbers' => 0.3,
      'Philadelphia Union' => 0.44,
      'Real Salt Lake' => 0.42,
      'San Jose Earthquakes' => 0.33,
      'Seattle Sounders FC' => 0.5,
      'Toronto FC' => 0.33,
      'Vancouver Whitecaps FC' => 0.44,
      'Chicago Red Stars' => 0.48,
      'Houston Dash' => 0.1,
      'North Carolina Courage' => 0.2,
      'Orlando Pride' => 0.47,
      'Portland Thorns FC' => 0.45,
      'Reign FC' => 0.33,
      'Sky Blue FC' => 0.3,
      'Utah Royals FC' => 0.6,
      'Washington Spirit FC' => 0.67,
      'Columbus Crew SC' => 0.5
    }

    expected2 = {
      'Atlanta United' => 0.6,
      'Chicago Fire' => 0.8,
      'Chicago Red Stars' => 0.63,
      'Columbus Crew SC' => 0.75,
      'DC United' => 1.0,
      'FC Cincinnati' => 0.56,
      'FC Dallas' => 0.7,
      'Houston Dash' => 0.4,
      'Houston Dynamo' => 0.7,
      'LA Galaxy' => 0.36,
      'Los Angeles FC' => 0.56,
      'Montreal Impact' => 0.61,
      'New England Revolution' => 0.63,
      'New York City FC' => 0.8,
      'New York Red Bulls' => 0.7,
      'North Carolina Courage' => 0.5,
      'Orlando City SC' => 0.59,
      'Orlando Pride' => 0.6,
      'Philadelphia Union' => 0.56,
      'Portland Thorns FC' => 0.55,
      'Portland Timbers' => 0.5,
      'Real Salt Lake' => 0.74,
      'Reign FC' => 0.67,
      'San Jose Earthquakes' => 0.67,
      'Seattle Sounders FC' => 0.6,
      'Sky Blue FC' => 0.6,
      'Sporting Kansas City' => 0.44,
      'Toronto FC' => 0.61,
      'Utah Royals FC' => 0.7,
      'Vancouver Whitecaps FC' => 0.63,
      'Washington Spirit FC' => 0.78
    }

    assert_includes [expected1, expected2], @stat_tracker.head_to_head('18')
  end

  def test_team_info
    expected = {
      'team_id' => '18',
      'franchise_id' => '34',
      'team_name' => 'Minnesota United FC',
      'abbreviation' => 'MIN',
      'link' => '/api/v1/teams/18'
    }
    assert_equal expected, @stat_tracker.team_info('18')
  end

  def test_average_win_percentage
    assert_equal 0.49, @stat_tracker.average_win_percentage('6')
  end

  def test_all_team_games
    expected = @stat_tracker.all_team_games('18').first

    assert_equal expected, @stat_tracker.all_team_games('18')[0]
  end

  def test_team_biggest_blowout
    assert_equal 5, @stat_tracker.biggest_team_blowout('18')
  end

  def test_a_team_can_get_a_seasonal_summary
    expected = { '20162017' =>
      { postseason: { win_percentage: 0.59,
                      total_goals_scored: 48,
                      total_goals_against: 40,
                      average_goals_scored: 2.18,
                      average_goals_against: 1.82 },
        regular_season: { win_percentage: 0.38,
                          total_goals_scored: 180,
                          total_goals_against: 170,
                          average_goals_scored: 2.2,
                          average_goals_against: 2.07 } },
                 '20172018' =>
      { postseason: { win_percentage: 0.54,
                      total_goals_scored: 29,
                      total_goals_against: 28,
                      average_goals_scored: 2.23,
                      average_goals_against: 2.15 },
        regular_season: { win_percentage: 0.44,
                          total_goals_scored: 187,
                          total_goals_against: 162,
                          average_goals_scored: 2.28,
                          average_goals_against: 1.98 } },
                 '20132014' =>
      { postseason: { win_percentage: 0.0,
                      total_goals_scored: 0,
                      total_goals_against: 0,
                      average_goals_scored: 0.0,
                      average_goals_against: 0.0 },
        regular_season: { win_percentage: 0.38,
                          total_goals_scored: 166,
                          total_goals_against: 177,
                          average_goals_scored: 2.02,
                          average_goals_against: 2.16 } },
                 '20122013' =>
      { postseason: { win_percentage: 0.0,
                      total_goals_scored: 0,
                      total_goals_against: 0,
                      average_goals_scored: 0.0,
                      average_goals_against: 0.0 },
        regular_season: { win_percentage: 0.25,
                          total_goals_scored: 85,
                          total_goals_against: 103,
                          average_goals_scored: 1.77,
                          average_goals_against: 2.15 } },
                 '20142015' =>
      { postseason: { win_percentage: 0.67,
                      total_goals_scored: 17,
                      total_goals_against: 13,
                      average_goals_scored: 2.83,
                      average_goals_against: 2.17 },
        regular_season: { win_percentage: 0.5,
                          total_goals_scored: 186,
                          total_goals_against: 162,
                          average_goals_scored: 2.27,
                          average_goals_against: 1.98 } },
                 '20152016' =>
      { postseason: { win_percentage: 0.36,
                      total_goals_scored: 25,
                      total_goals_against: 33,
                      average_goals_scored: 1.79,
                      average_goals_against: 2.36 },
        regular_season: { win_percentage: 0.45,
                          total_goals_scored: 178,
                          total_goals_against: 159,
                          average_goals_scored: 2.17,
                          average_goals_against: 1.94 } } }

    assert_equal expected, @stat_tracker.seasonal_summary('18')
  end
end
