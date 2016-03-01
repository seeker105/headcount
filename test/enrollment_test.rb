require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_can_create_enrollment_object
    enrollment = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_kind_of Enrollment, enrollment
  end

  def test_kindergarten_participat_by_year_returns_hash
    skip
    # name       = "academy 20"
    # enrollment = Enrollment.new({:name => name})
    # submitted  = enrollment.name
    # expected   = name.upcase
    #
    # assert_equal expected, submitted
  end

end
