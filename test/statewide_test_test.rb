require 'simplecov'
SimpleCov.start
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative './test_helper'

class StatewideTestTest < Minitest::Test
  include TestHelper

  @@stw_test = @@stw_test_repo.statewide_tests.first

  def test_can_create_statewidetest_object
    assert_kind_of StatewideTest, @@stw_test
  end

  def test_proficient_by_grade_returns_error_with_unknown_grade
    assert_raises UnknownDataError do
      @@stw_test.proficient_by_grade(2)
    end
  end

  def test_proficient_by_grade_returns_hash_of_all_third_grade_data
    submitted = @@stw_test.proficient_by_grade(3)
    expected  = {2008 => {:math=>0.697, :reading=>0.703, :writing=>0.501},
                 2009 => {:math=>0.691, :reading=>0.726, :writing=>0.536},
                 2010 => {:math=>0.706, :reading=>0.698, :writing=>0.504},
                 2011 => {:math=>0.696, :reading=>0.728, :writing=>0.513},
                 2012 => {:reading=>0.739, :math=>0.71, :writing=>0.525},
                 2013 => {:math=>0.722, :reading=>0.732, :writing=>0.509},
                 2014 => {:math=>0.715, :reading=>0.715, :writing=>0.510}}

    assert_equal expected, submitted
  end

  def test_proficient_by_grade_returns_hash_of_all_eighth_grade_data
    submitted = @@stw_test.proficient_by_grade(8)
    expected  = {2008 => {:math=>0.469, :reading=>0.703, :writing=>0.529},
                 2009 => {:math=>0.499, :reading=>0.726, :writing=>0.528},
                 2010 => {:math=>0.51, :reading=>0.679, :writing=>0.549},
                 2011 => {:reading=>0.67, :math=>0.513, :writing=>0.543},
                 2012 => {:math=>0.515, :writing=>0.548, :reading=>0.671},
                 2013 => {:math=>0.514, :reading=>0.668, :writing=>0.557},
                 2014 => {:math=>0.523, :reading=>0.663, :writing=>0.561}}

    assert_equal expected, submitted
  end

  def test_proficient_by_race_or_ethnicity_returns_error_with_unknown_race
    assert_raises UnknownRaceError do
      @@stw_test.proficient_by_race_or_ethnicity(:Hobbit)
    end
  end

  def test_proficient_by_race_or_ethnicity_returns_race_specific_data
    submitted = @@stw_test.proficient_by_race_or_ethnicity(:asian)
    expected = {2011 => {:math=>0.709, :reading=>0.748, :writing=>0.656},
                2012 => {:math=>0.719, :reading=>0.757, :writing=>0.658},
                2013 => {:math=>0.732, :reading=>0.769, :writing=>0.682},
                2014 => {:math=>0.734, :reading=>0.769, :writing=>0.684}}

    assert_equal expected, submitted
  end

  def test_proficient_for_subject_by_grade_in_year_returns_error_with_bad_subject
    assert_raises UnknownDataError do
      @@stw_test.proficient_for_subject_by_grade_in_year(:science, 8, 2010)
    end
  end

  def test_proficient_for_subject_by_grade_in_year
    submitted = @@stw_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
    expected  = 0.697

    assert_equal expected, submitted
  end

  def test_proficient_for_race_by_subject_in_year_returns_error_with_bad_subject
    assert_raises UnknownDataError do
      @@stw_test.proficient_for_subject_by_race_in_year(:magic, :asian, 2012)
    end
  end

  def test_proficient_for_race_by_subject_in_year_returns_error_with_bad_race
    assert_raises UnknownDataError do
      @@stw_test.proficient_for_subject_by_race_in_year(:math, :hobbit, 2012)
    end
  end

  def test_proficient_for_race_by_subject_in_year
    submitted = @@stw_test.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
    expected  = 0.719

    assert_equal expected, submitted
  end

end
