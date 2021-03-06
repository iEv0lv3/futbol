require_relative './test_helper'
require 'csv'
require './lib/collection'
require './lib/game'
require './lib/team'
require './lib/game_teams'
require './lib/game_collection'
require './lib/team_collection'
require './lib/game_teams_collection'

class CollectionTest < Minitest::Test
  def setup
    @games = './test/fixtures/games_truncated.csv'
    @teams = './test/fixtures/teams_truncated.csv'
    @game_teams = './test/fixtures/game_teams_truncated.csv'
  end

  def test_collection_exists
    collection1 = Collection.new(@games, Game)

    assert_instance_of Collection, collection1
  end

  def test_collection_attributes_game
    collection1 = Collection.new(@games, Game)
    games = collection1.collection

    assert_equal '17', games['2012030233'].home_team_id
  end

  def test_collection_attributes_team
    collection1 = Collection.new(@teams, Team)
    teams = collection1.collection

    assert_equal 'DC', teams['14'].abbreviation
  end

  def test_csv_read_method_opens_file
    teams = Collection.new(@teams, Team)

    assert_equal 'ATL', teams.collection['1'].abbreviation
  end

  def test_create_collection_opens_csv_and_parses_to_hash
    teams = Collection.new(@teams, Team)

    assert_equal 'CHI', teams.collection['4'].abbreviation
  end
end
