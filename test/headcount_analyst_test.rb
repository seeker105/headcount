require_relative './test_helper'

class HeadcountAnalystTest < Minitest::Test
  include TestHelper

  def test_it_can_initialize_with_a_new_district_repository
    assert_kind_of HeadcountAnalyst, @@headcount_analyst
  end

  def test_it_returns_the_kindergarten_participation_rate_variation_with_state_avg
    submitted = @@headcount_analyst.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    expected  = 0.766

    assert_equal expected, submitted
  end

  def test_it_returns_the_kindergarten_participation_rate_variation
    submitted = @@headcount_analyst.kindergarten_participation_rate_variation("GUNNISON WATERSHED RE1J", :against => "TELLURIDE R-1")
    expected  = 1.126

    assert_equal expected, submitted
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_single
    submitted = @@headcount_analyst.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')

    assert submitted
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_statewide
    submitted = @@headcount_analyst.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')

    refute submitted
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation
    array     = ['ACADEMY 20', 'AGATE 300', 'CHERAW 31']
    submitted = @@headcount_analyst.kindergarten_participation_correlates_with_high_school_graduation(across: array)

    refute submitted
  end

  def test_top_statewide_test_year_over_year_growth_insufficient_information_error
    args = {subject: :math}
    assert_raises InsufficientInformationError do
      @@headcount_analyst.top_statewide_test_year_over_year_growth(args)
    end
  end

  def test_top_statewide_test_year_over_year_growth_unknown_data_error
    args = {grade: 9, subject: :math}
    assert_raises UnknownDataError do
      @@headcount_analyst.top_statewide_test_year_over_year_growth(args)
    end
  end

  def test_top_statewide_test_year_over_year_growth_third_grade_math
    args      = {grade: 3, subject: :math}
    submitted = @@headcount_analyst.top_statewide_test_year_over_year_growth(args)
    expected  = ["WILEY RE-13 JT", 0.3]

    assert_equal submitted, expected
  end

  def test_top_statewide_test_year_over_year_growth_eighth_grade_reading
    args      = {grade: 8, subject: :reading}
    submitted = @@headcount_analyst.top_statewide_test_year_over_year_growth(args)
    expected  = ["COTOPAXI RE-3", 0.131]

    assert_equal submitted, expected
  end

  def test_top_statewide_test_year_over_year_growth_third_grade
    args      = {grade: 3}
    submitted = @@headcount_analyst.top_statewide_test_year_over_year_growth(args)
    expected  = ["SANGRE DE CRISTO RE-22J", 0.071]

    assert_equal submitted, expected
  end

  def test_top_statewide_test_year_over_year_growth_eighth_grade
    args      = {grade: 8}
    submitted = @@headcount_analyst.top_statewide_test_year_over_year_growth(args)
    expected  = ["OURAY R-1", 0.11]

    assert_equal submitted, expected
  end

  def test_top_statewide_test_year_over_year_growth_top_three_third_grade
    args      = {grade: 3, top: 3, subject: :math}
    submitted = @@headcount_analyst.top_statewide_test_year_over_year_growth(args)
    expected  = [ ["WILEY RE-13 JT", 0.3],
                  ["SANGRE DE CRISTO RE-22J", 0.071],
                  ["COTOPAXI RE-3", 0.069] ]

    assert_equal 3, expected.length
    assert_equal submitted, expected
  end

  def test_top_statewide_test_year_over_year_growth_top_five_third_grade
    args      = {grade: 3, top: 5, subject: :math}
    submitted = @@headcount_analyst.top_statewide_test_year_over_year_growth(args)
    expected  = [ ["WILEY RE-13 JT", 0.3], ["SANGRE DE CRISTO RE-22J", 0.071],
                  ["COTOPAXI RE-3", 0.069], ["MANCOS RE-6", 0.051], ["OTIS R-3", 0.05] ]

    assert_equal 5, expected.length
    assert_equal submitted, expected
  end

  def test_top_statewide_test_year_over_year_growth_weighted
    args    = {grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0}}
    submitted = @@headcount_analyst.top_statewide_test_year_over_year_growth(args)
    expected  = ["OURAY R-1", 0.153]

    assert_equal submitted, expected
  end

  def test_top_statewide_test_year_over_year_growth_weights_over_one
    args = {grade: 8, :weighting => {:math => 1.5, :reading => 0.5, :writing => 0.0}}
    assert_raises ArgumentError do
      @@headcount_analyst.top_statewide_test_year_over_year_growth(args)
    end
  end

  def test_top_statewide_test_year_over_year_growth_weights_under_one
    args = {grade: 8, :weighting => {:math => 0.25, :reading => 0.25, :writing => 0.0}}
    assert_raises ArgumentError do
      @@headcount_analyst.top_statewide_test_year_over_year_growth(args)
    end
  end

end
