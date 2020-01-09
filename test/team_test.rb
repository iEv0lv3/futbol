require_relative 'test_helper'
require_relative '../lib/team'

class TeamTest < Minitest::Test
  def setup
    @team = mock('Team')
    @team.stubs(:klass).returns('Team')
    @team.stubs(:team_name).returns('Atlanta United')
    @team.stubs(:team_id).returns(1)
    @team.stubs(:franchise_id).returns(23)
    @team.stubs(:abbreviation).returns('ATL')
    @team.stubs(:stadium).returns('Mercedes-Benz Stadium')
  end

  def test_a_team_exists
    assert_equal 'Team', @team.klass
  end

  def test_a_team_has_attributes
    assert_equal 1, @team.team_id
    assert_equal 23, @team.franchise_id
    assert_equal 'Atlanta United', @team.team_name
    assert_equal 'ATL', @team.abbreviation
    assert_equal 'Mercedes-Benz Stadium', @team.stadium
  end
end
