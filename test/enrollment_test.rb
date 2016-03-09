require_relative './test_helper'

class EnrollmentTest < Minitest::Test
  include TestHelper

  @@enroll = @@district.enrollment

  def test_can_create_enrollment_object
    assert_kind_of Enrollment, @@enroll
  end

  def test_kindergarten_participant_by_year_returns_hash_of_years_and_percentages
    submitted = @@enroll.kindergarten_participation_by_year
    expected  = {
                  2007 => 0.391, 2006 => 0.353, 2005 => 0.267, 2004 => 0.302,
                  2008 => 0.384, 2009 => 0.39, 2010 => 0.436, 2011 => 0.489,
                  2012 => 0.478, 2013 => 0.487, 2014 => 0.49
                }

    assert_kind_of Hash, expected
    assert_equal expected, submitted
  end

  def test_kindergarten_participation_in_year_returns_nil_for_unknown_year
    submitted = @@enroll.kindergarten_participation_in_year(1980)

    assert_nil submitted
  end

  def test_kindergarten_participant_in_year_returns_float_percentage
    submitted = @@enroll.kindergarten_participation_in_year(2012)
    expected  = 0.478

    assert_equal expected, submitted
  end

  def test_can_return_graduation_rates_by_year
    submitted = @@enroll.graduation_rate_by_year
    expected  = {
                  2010 => 0.895, 2011 => 0.895, 2012 => 0.889,
                  2013 => 0.913, 2014 => 0.898
                }

    assert_equal expected, submitted
  end

  def test_can_return_graduation_avg_for_all_years
    submitted = @@enroll.graduation_avg_all_years
    expected  = 0.898

    assert_equal expected, submitted
  end

  def test_can_return_graduation_in_specific_year
    submitted = @@enroll.graduation_rate_in_year(2012)
    expected  = 0.889

    assert_equal expected, submitted
  end

  def test_graduation_rate_in_year_returns_nil_for_bad_year
    submitted = @@enroll.graduation_rate_in_year(1895)

    assert_nil submitted
  end

end
