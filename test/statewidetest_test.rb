require 'simplecov'
SimpleCov.start
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def setup
    @stw_test = StatewideTest.new(name: "ACADEMY 20",
      third_grade:  {2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671}},
      eighth_grade: {2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671}},
      math:         {2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671}},
      reading:      {2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671}},
      writing:      {2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671}})
  end

  def test_can_create_statewidetest_object
    assert_kind_of StatewideTest, @stw_test
  end

  def test_proficient_by_grade_returns_error_with_unknown_grade
    # needs to be UnknownDataError
    assert_raises UnknownDataError do
      @stw_test.proficient_by_grade(2)
    end
  end

  def test_proficient_by_grade_returns_hash_of_all_grade_data
    submitted = @stw_test.proficient_by_grade(3)
    expected  = {2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671}}

    assert_equal expected, submitted
  end

  def test_proficient_by_race_or_ethnicity_returns_error_with_unknown_race
    assert_raises UnknownRaceError do
      @stw_test.proficient_by_race_or_ethnicity(:Hobbit)
    end
  end

  def test_proficient_by_race_or_ethnicity_returns_race_specific_data
    skip
  end

end
