require_relative './test_helper'
require_relative '../lib/enrollment_repository'
require_relative '../lib/enrollment'

class EnrollmentRepositoryTest < Minitest::Test
  include TestHelper

  @@enrollment = @@enrollment_repo.find_by_name("ACADEMY 20")

  def test_can_create_enrollment_repo_object
    assert_kind_of EnrollmentRepository, @@enrollment_repo
  end

  def test_find_by_name_returns_enrollment_object
    submitted = @@enrollment

    assert_kind_of Enrollment, submitted
  end

  def test_find_by_name_insensitive_search_returns_enrollment_object
    submitted = @@enrollment_repo.find_by_name("academy 20")

    assert_kind_of Enrollment, submitted
    assert_equal "ACADEMY 20", submitted.name
  end

  def test_find_by_name_returns_nil_with_no_matching_enrollment_object
    submitted = @@enrollment_repo.find_by_name("LASER SCHOOL")

    assert_nil submitted
  end

  def test_repo_can_load_data
    repo = EnrollmentRepository.new

    assert_nil repo.enrollments

    submitted = repo.load_data({ enrollment: {
      kindergarten: "./data/Kindergartners in full-day program.csv",
      high_school_graduation: "./data/High school graduation rates.csv"} })

    assert_equal 181, repo.enrollments.count
  end

end
