require_relative './test_helper'
require 'csv'
require './lib/collection'
require './lib/team_collection'

class TeamCollectionTest < Minitest::Test
  def setup
    @collection = TeamCollection.new('./test/fixtures/teams_truncated.csv')
    @team = @collection.collection.first
  end

  def test_team_collection_exists
    assert_instance_of TeamCollection, @collection
  end

  def test_team_collection_has_teams
    assert_equal 'ATL', @team[1].abbreviation
  end
end
