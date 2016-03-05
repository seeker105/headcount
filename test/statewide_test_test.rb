require 'simplecov'
SimpleCov.start
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/statewide_test_repository'
require_relative '../lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def setup
    stw_test_repo = StatewideTestRepository.new
    stw_test_repo.load_data({ :statewide_testing => {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"}
      })
    @stw_test = stw_test_repo.stw_tests.first
  end

  def test_can_create_statewidetest_object
    assert_kind_of StatewideTest, @stw_test
  end

  def test_proficient_by_grade_returns_error_with_unknown_grade
    assert_raises UnknownDataError do
      @stw_test.proficient_by_grade(2)
    end
  end

  def test_proficient_by_grade_returns_hash_of_all_grade_data
    submitted = @stw_test.proficient_by_grade(3)
    expected  = {2008 => {:math=>0.697, :reading=>0.703, :writing=>0.501},
                 2009 => {:math=>0.691, :reading=>0.726, :writing=>0.536},
                 2010 => {:math=>0.706, :reading=>0.698, :writing=>0.504},
                 2011 => {:math=>0.696, :reading=>0.728, :writing=>0.513},
                 2012 => {:reading=>0.739, :math=>0.71, :writing=>0.525},
                 2013 => {:math=>0.722, :reading=>0.732, :writing=>0.509},
                 2014 => {:math=>0.715, :reading=>0.715, :writing=>0.510}}

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
