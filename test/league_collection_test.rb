require_relative './test_helper'
require 'csv'
require_relative '../lib/league_collection'

class LeagueCollectionTest < Minitest::Test
  def setup
    # @collection = LeagueCollection.new('./test/fixtures/league_truncated.csv')
    # @league = @collection.league.first
  end

  def test_team_collection_exists
    assert_instance_of LeagueCollection, @collection
  end

  def test_league_collection_has_league
    assert_instance_of Array, @collection.league
  end

  def test_league_collection_can_create_league_from_csv
    assert_instance_of League, @league
  end
end
