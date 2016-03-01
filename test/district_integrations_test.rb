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

    binding.pry
    district_repo.load_enrollments(enrollment_repo)

    assert_equal enrollment, district_repo.find_by_name("ACADEMY 20").enrollment
  end

end
