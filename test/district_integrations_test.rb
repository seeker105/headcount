require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district_repository'
require_relative '../lib/enrollment_repository'
require_relative '../lib/district'
require_relative '../lib/enrollment'

class DistrictRepositoryIntegrationsTest < Minitest::Test

  def test_district_can_view_enrollments
    skip
    district_1     = District.new({name: "ACADEMY 20"})
    district_repo  = DistrictRepository.new([district_1])

    enrollment     = Enrollment.new({name: "ACADEMY 20",
                     :kindergarten_participation => { 2010 => 0.3915,
                                                      2011 => 0.35356,
                                                      2012 => 0.2677 }})
    enrollment_repo = EnrollmentRepository.new([enrollment])

    district_repo.load_enrollments(enrollment_repo)

    submitted = district_repo.find_by_name("ACADEMY 20")

    assert_equal enrollment, submitted.enrollment
    assert_equal 0.391, submitted.enrollment.kindergarten_participation_in_year(2010)
  end

  def test_district_can_view_enrollments_alt
    # skip
    district_1     = District.new({name: "ACADEMY 20"})
    district_repo  = DistrictRepository.new([district_1])

    enrollment     = Enrollment.new({name: "ACADEMY 20",
                     :kindergarten_participation => { 2010 => 0.3915,
                                                      2011 => 0.35356,
                                                      2012 => 0.2677 }})
    enrollment_repo = EnrollmentRepository.new([enrollment])

    district_repo.enrollment_repo = enrollment_repo
    district_repo.load_enrollments

    submitted = district_repo.find_by_name("ACADEMY 20")

    assert_equal enrollment, submitted.enrollment
    assert_equal 0.391, submitted.enrollment.kindergarten_participation_in_year(2010)
  end

  def test_district_can_process_enrollment_with_two_csvs
    # skip
    district_repo  = DistrictRepository.new
    district_repo.load_data(:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"})

    district_repo.load_enrollments

    submitted = district_repo.find_by_name("ACADEMY 20")

    assert_equal 0.436, submitted.enrollment.kindergarten_participation_in_year(2010)
  end



end
