require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enrollment_repository'
require_relative '../lib/enrollment'

class EnrollmentRepositoryTest < Minitest::Test

  def setup
    @enrollment_repo = EnrollmentRepository.new
  end

  def test_can_create_enrollment_repo_object
    # skip
    assert_kind_of EnrollmentRepository, @enrollment_repo
  end

  def test_can_find_enrollment_by_name
    skip
    enroll = Enrollment.new({name: "ACADEMY 20",
             kindergarten_participation: { 2010 => 0.3915,
                                           2011 => 0.35356,
                                           2012 => 0.2677 }})
    e_repo = EnrollmentRepository.new(enroll)

    submitted = e_repo.find_by_name("academy 20")

    assert_equal enroll, submitted
  end

  def test_load_can_accept_hash
    skip
    @enrollment_repo.load_data({:enrollment => {
                                :kindergarten => "./data/Kindergartners in full-day program.csv"}
                               })


  end

end
