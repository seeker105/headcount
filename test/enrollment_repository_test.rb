require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def setup
    @enrollment_repo = EnrollmentRepository.new
  end

  def test_can_create_enrollment_repo_object
    # skip
    assert_kind_of EnrollmentRepository, @enrollment_repo
  end

  def test_load_can_accept_hash
    skip
    @enrollment_repo.load_data({:enrollment => {
                                :kindergarten => "./data/Kindergartners in full-day program.csv"}
                               })


  end

end
