require 'simplecov'
SimpleCov.start
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative './test_helper'
require_relative '../lib/economic_profile'

class EconomicProfileTest < Minitest::Test
  include TestHelper

  @@econ_profile = @@economic_profile_repo.find_by_name('ACADEMY 20')

  def test_median_hosehould_income_in_year_returns_median
    submitted = @@econ_profile.median_household_income_in_year(2010)
    expected  = 88279

    assert_equal expected, submitted
  end

end
