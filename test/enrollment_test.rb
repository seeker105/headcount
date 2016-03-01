require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_can_create_enrollment_object
    enroll = Enrollment.new({:name => "ACADEMY 20",
                             :kindergarten_participation => {2010 => 0.3915,
                                                             2011 => 0.35356,
                                                             2012 => 0.2677}
                            })
    assert_kind_of Enrollment, enroll
  end

  def test_kindergarten_participant_by_year_returns_hash_of_years_and_percentages
    # skip
    enroll = Enrollment.new({:name => "ACADEMY 20",
                             :kindergarten_participation => {2010 => 0.3915,
                                                             2011 => 0.35356,
                                                             2012 => 0.2677}
                            })
    submitted  = enroll.kindergarten_participation_by_year
    expected   = {2010 => 0.3915,
                  2011 => 0.35356,
                  2012 => 0.2677}

    assert_equal expected, submitted
    assert_kind_of Hash, expected
  end

end
