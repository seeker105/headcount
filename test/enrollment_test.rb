require 'simplecov'
SimpleCov.start
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test

  def setup
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 1a4468701af69f3f98020d3156b0f251807a099b
    @enroll = Enrollment.new({name: "ACADEMY 20",
              kindergarten_participation: { 2010 => 0.3915,
                                            2011 => 0.35356,
                                            2012 => 0.2677 }})
<<<<<<< HEAD
=======
=======
    @enroll = Enrollment.new({:name => "ACADEMY 20",
              :kindergarten_participation => { 2010 => 0.3915,
                                               2011 => 0.35356,
                                               2012 => 0.2677 },
              :high_school_graduation => { 2010 => 0.3434,
                2011 => 0.6845,
                2012 => 0.1123 }})
>>>>>>> master
>>>>>>> 1a4468701af69f3f98020d3156b0f251807a099b
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

<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 1a4468701af69f3f98020d3156b0f251807a099b
  def test_can_return_graduation_rates_by_year
    # skip
    enroll = Enrollment.new({name: "ACADEMY 20",
                   kindergarten_participation: { 2010 => 0.3915,
                                                 2011 => 0.35356,
                                                 2012 => 0.2677,
                                                 2013 => 0.48774,
                                                 2014 => 0.49022 },
                   high_school_graduation: { 2010 => 0.895,
                                             2011 => 0.895,
                                             2012 => 0.88983,
                                             2013 => 0.91373,
                                             2014 => 0.898 }})

    submitted = enroll.graduation_rate_by_year
    expected = { 2010 => 0.895,
                 2011 => 0.895,
                 2012 => 0.889,
                 2013 => 0.913,
                 2014 => 0.898 }

    assert_equal expected, submitted
  end

  def test_can_return_graduation_avg_for_all_years
    # skip
    enroll = Enrollment.new({name: "ACADEMY 20",
                   kindergarten_participation: { 2010 => 0.3915,
                                                 2011 => 0.35356,
                                                 2012 => 0.2677,
                                                 2013 => 0.48774,
                                                 2014 => 0.49022 },
                   high_school_graduation: { 2010 => 0.895,
                                             2011 => 0.895,
                                             2012 => 0.88983,
                                             2013 => 0.91373,
                                             2014 => 0.898 }})

    submitted = enroll.graduation_avg_all_years
    expected  = 0.898

    assert_equal expected, submitted
  end

  def test_can_return_graduation_in_specific_year
    # skip
    enroll = Enrollment.new({name: "ACADEMY 20",
                   kindergarten_participation: { 2010 => 0.3915,
                                                 2011 => 0.35356,
                                                 2012 => 0.2677,
                                                 2013 => 0.48774,
                                                 2014 => 0.49022 },
                   high_school_graduation: { 2010 => 0.895,
                                             2011 => 0.895,
                                             2012 => 0.88983,
                                             2013 => 0.91373,
                                             2014 => 0.898 }})

    submitted = enroll.graduation_rate_in_year(2012)
    expected  = 0.889
<<<<<<< HEAD
  end
=======
=======
  def test_graduation_rate_by_year_returns_the_correct_hash_of_years_and_rates
    # binding.pry
    submitted = @enroll.graduation_rate_by_year
    expected  = { 2010 => 0.343,
                  2011 => 0.684,
                  2012 => 0.112}
    assert_equal expected, submitted
  end

  def test_graduation_rate_in_year_returns_nil_for_an_unknown_year
    submitted = @enroll.graduation_rate_in_year(1980)
    assert_nil submitted
  end
>>>>>>> master
>>>>>>> 1a4468701af69f3f98020d3156b0f251807a099b

  def test_graduation_rate_in_year_returns_rate_for_a_given_year
    submitted = @enroll.graduation_rate_in_year(2010)
    expected = 0.343
    assert_equal expected, submitted
  end

end
