require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test

  def setup
    @enroll = Enrollment.new({:name => "ACADEMY 20",
              :kindergarten_participation => { 2010 => 0.3915,
                                               2011 => 0.35356,
                                               2012 => 0.2677 }})
  end

  def test_can_create_enrollment_object
    assert_kind_of Enrollment, @enroll
  end

  def test_kindergarten_participant_by_year_returns_hash_of_years_and_percentages
    submitted = @enroll.kindergarten_participation_by_year
    expected  = { 2010 => 0.391,
                  2011 => 0.353,
                  2012 => 0.267 }

    assert_kind_of Hash, expected
    assert_equal expected, submitted
  end

  def test_kindergarten_participant_in_year_returns_nil_for_unknown_year
    submitted = @enroll.kindergarten_participation_in_year(1980)
    assert_nil submitted
  end

  def test_kindergarten_participant_in_year_raises_arg_error_if_non_fixnum_submitted
    assert_raises ArgumentError do
      @enroll.kindergarten_participation_in_year("1980")
    end
  end

  def test_kindergarten_participant_in_year_returns_float_percentage
    submitted = @enroll.kindergarten_participation_in_year(2012)
    expected  = 0.267

    assert_equal expected, submitted
  end

end
