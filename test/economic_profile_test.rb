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

  def test_median_hosehould_income_in_year_returns_arg_error_for_non_fixnums
    assert_raises UnknownDataError do
      @@econ_profile.median_household_income_in_year("2010")
    end
  end

  def test_median_hosehould_income_in_year_returns_arg_error_for_unknown_year
    assert_raises UnknownDataError do
      @@econ_profile.median_household_income_in_year(1807)
    end
  end

  def test_median_hosehould_income_average_returns_average
    submitted = @@econ_profile.median_household_income_average
    expected  = 87635

    assert_equal expected, submitted
  end

  def test_children_in_poverty_in_year_returns_float
    submitted = @@econ_profile.children_in_poverty_in_year(2010)
    expected  = 0.057

    assert_equal expected, submitted
  end

  def test_children_in_poverty_in_year_returns_arg_error_for_string
    assert_raises UnknownDataError do
      @@econ_profile.children_in_poverty_in_year("2010")
    end
  end

  def test_children_in_poverty_in_year_returns_arg_error_for_unknown_year
    assert_raises UnknownDataError do
      @@econ_profile.children_in_poverty_in_year(1807)
    end
  end

  def test_free_or_reduced_price_lunch_percentage_in_year_returns_float
    submitted = @@econ_profile.free_or_reduced_price_lunch_percentage_in_year(2010)
    expected  = 0.113

    assert_equal expected, submitted
  end

  def test_free_or_reduced_price_lunch_percentage_in_year_returns_arg_error_for_string
    assert_raises UnknownDataError do
      @@econ_profile.free_or_reduced_price_lunch_percentage_in_year("2010")
    end
  end

  def test_free_or_reduced_price_lunch_percentage_in_year_returns_arg_error_for_unknown_year
    assert_raises UnknownDataError do
      @@econ_profile.free_or_reduced_price_lunch_percentage_in_year(1900)
    end
  end

  def test_free_or_reduced_price_lunch_number_in_year_returns_float
    submitted = @@econ_profile.free_or_reduced_price_lunch_number_in_year(2010)
    expected  = 2601

    assert_equal expected, submitted
  end

  def test_free_or_reduced_price_lunch_number_in_year_returns_arg_error_for_string
    assert_raises UnknownDataError do
      @@econ_profile.free_or_reduced_price_lunch_number_in_year("2010")
    end
  end

  def test_free_or_reduced_price_lunch_number_in_year_returns_arg_error_for_unknown_year
    assert_raises UnknownDataError do
      @@econ_profile.free_or_reduced_price_lunch_number_in_year(1900)
    end
  end

  def test_title_i_in_year_returns_float
    submitted = @@econ_profile.title_i_in_year(2013)
    expected  = 0.012

    assert_equal expected, submitted
  end

  def test_title_i_in_year_returns_arg_error_for_string
    assert_raises UnknownDataError do
      @@econ_profile.title_i_in_year("2010")
    end
  end

  def test_title_i_in_year_returns_arg_error_for_unknown_year
    assert_raises UnknownDataError do
      @@econ_profile.title_i_in_year(1900)
    end
  end

end
