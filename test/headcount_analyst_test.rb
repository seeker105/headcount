require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district_repository'
require_relative '../lib/district'
require_relative '../lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def setup
    district_1     = District.new({name: "ACADEMY 20"})
    district_2     = District.new({name: "COLORADO"})
    district_repo  = DistrictRepository.new([district_1, district_2])
    enrollment_1   = Enrollment.new({name: "ACADEMY 20",
                     :kindergarten_participation => { 2010 => 0.3915,
                                                      2011 => 0.35356,
                                                      2012 => 0.2677 }})
    enrollment_2    = Enrollment.new({name: "COLORADO",
                     :kindergarten_participation => { 2010 => 0.64019,
                                                      2011 => 0.672,
                                                      2012 => 0.695 }})
    enrollment_repo = EnrollmentRepository.new([enrollment_1, enrollment_2])
    district_repo.load_enrollments(enrollment_repo)
    @h_analyst      = HeadcountAnalyst.new(district_repo)
  end

  def test_it_can_initialize_with_a_new_district_repository
    assert_kind_of HeadcountAnalyst, @h_analyst
  end

  def test_it_returns_the_kindergarten_participation_rate_variation
    colorado_truncated_avg = 0.669
    academy_truncated_avg  = 0.337
    truncated_rate_variation = 0.504
    submitted = @h_analyst.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')

    assert_equal truncated_rate_variation, submitted
  end

  def test_it_returns_the_kindergarten_participation_rate_trend
    colorado_truncated_avg = 0.669
    academy_truncated_avg  = 0.337
    truncated_rate_variation = 0.504
    submitted = @h_analyst.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')

    assert_equal truncated_rate_variation, submitted
  end

end