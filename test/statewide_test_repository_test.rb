require 'simplecov'
SimpleCov.start
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative './test_helper'

class StatewideTestRepositoryTest < Minitest::Test
  include TestHelper

  def test_can_create_statewide_test_repo
    assert_kind_of StatewideTestRepository, @@stw_test_repo
  end

  def test_statewide_test_repo_finds_a_statewide_test_by_name
    name      = 'ACADEMY 20'
    submitted = @@stw_test_repo.find_by_name(name)

    assert_kind_of StatewideTest, submitted
    assert_equal name, submitted.name
  end

end
