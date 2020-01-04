require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require './lib/game_teams_collection'

class GameTeamCollectionTest < Minitest::Test
  def test_game_team_collection_exists
    collection = GameTeamCollection.new('./test/fixtures/game_teams_truncated.csv')
    game_teams_path = './data/game_teams.csv'

    collection = GameTeamsCollection.new(game_teams_path)

    assert_instance_of GameTeamsCollection, collection
  end

  def test_game_team_collection_has_game_team_instance_variable
    collection = GameTeamCollection.new('./test/fixtures/game_teams_truncated.csv')

    assert_equal 9, collection.game_teams.length
  end

  def test_file_path_location
    collection = GameTeamCollection.new('./test/fixtures/game_teams_truncated.csv')
    game_teams_path = './data/game_teams.csv'

    collection = GameTeamsCollection.new(game_teams_path)

    assert_nil collection.collection
  end

  def test_file_path_location
    game_teams_path = './data/game_teams.csv'

    collection = GameTeamsCollection.new(game_teams_path)

    assert_equal './data/game_teams.csv', collection.game_teams_file_path
  end

  def test_game_team_collection_can_have_csv_data_added
    collection = GameTeamCollection.new('./test/fixtures/game_teams_truncated.csv')
    game_teams_path = './data/game_teams.csv'

    collection = GameTeamsCollection.new(game_teams_path)

    refute_nil collection.from_csv
  end
end
