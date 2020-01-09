require_relative './test_helper'
require './lib/season'
require './lib/collection'
require './lib/season_collection'
require './lib/game'
require 'csv'

class SeasonTest < Minitest::Test
  def setup
    seasons = mock('SeasonCollection')
    seasons.stubs(:klass).returns('SeasonCollection')
  end

  def test_team_collection_exists
    assert_equal 'SeasonCollection', seasons.klass
  end
end
