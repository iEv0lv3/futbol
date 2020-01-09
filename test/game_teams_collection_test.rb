require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require './lib/game_teams_collection'

class GameTeamsCollectionTest < Minitest::Test
  def test_game_team_collection_exists
    game_teams_path = './data/game_teams.csv'

    collection = GameTeamsCollection.new(game_teams_path)

    assert_instance_of GameTeamsCollection, collection
  end

  def test_file_path_location
    game_teams_path = './data/game_teams.csv'

    assert_equal './data/game_teams.csv', game_teams_path
  end

  def test_game_team_collection_can_have_csv_data_added
    game_teams_path = './data/game_teams.csv'

    collection = GameTeamsCollection.new(game_teams_path)

    assert_equal 'John Tortorella', collection.collection["2012030221a"].head_coach
  end
end
