<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 1a4468701af69f3f98020d3156b0f251807a099b
require 'simplecov'
SimpleCov.start
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

  def test_find_by_name_returns_enrollment_object
    # skip
    enrollment_1 = Enrollment.new({name: "ACADEMY 20",
                   kindergarten_participation: { 2010 => 0.3915,
                                                 2011 => 0.35356,
                                                 2012 => 0.2677 }})
    e_repo = EnrollmentRepository.new([enrollment_1])

    submitted = e_repo.find_by_name("ACADEMY 20")

    assert_equal enrollment_1, submitted
  end

  def test_find_by_name_insensitive_search_returns_enrollment_object
    # skip
    enrollment_1 = Enrollment.new({name: "ACADEMY 20",
                   kindergarten_participation: { 2010 => 0.3915,
                                                 2011 => 0.35356,
                                                 2012 => 0.2677 }})
    e_repo = EnrollmentRepository.new([enrollment_1])

    submitted = e_repo.find_by_name("academy 20")

    assert_equal enrollment_1, submitted
  end

  def test_find_by_name_returns_nil_with_no_matching_enrollment_object
    # skip
    enrollment_1 = Enrollment.new({name: "ACADEMY 20",
                   kindergarten_participation: { 2010 => 0.3915,
                                                 2011 => 0.35356,
                                                 2012 => 0.2677 }})
    e_repo = EnrollmentRepository.new([enrollment_1])

    submitted = e_repo.find_by_name("LASER SCHOOL")

    assert_nil submitted
  end
<<<<<<< HEAD
=======
=======
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enrollment'
require_relative '../lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test
    def setup
      @enrollment_repo = EnrollmentRepository.new
    end

    def test_can_create_enrollment_repo_object
      # skip
      assert_kind_of EnrollmentRepository, @enrollment_repo
    end

    def test_can_find_enrollment_by_name_insensitive_search
      # skip
      enrollment_1 = Enrollment.new({name: "ACADEMY 20",
                     kindergarten_participation: { 2010 => 0.3915,
                                                   2011 => 0.35356,
                                                   2012 => 0.2677 }})
      e_repo = EnrollmentRepository.new
      e_repo.enrollments = [enrollment_1]
      submitted = e_repo.find_by_name("academy 20")
      assert_equal enrollment_1, submitted
    end

    def test_can_find_enrollment_by_name_returns_nil_with_no_match
      # skip
      enrollment_1 = Enrollment.new({name: "ACADEMY 20",
                     kindergarten_participation: { 2010 => 0.3915,
                                                   2011 => 0.35356,
                                                   2012 => 0.2677 }})
      e_repo = EnrollmentRepository.new
      e_repo.enrollments = [enrollment_1]
      submitted = e_repo.find_by_name("LASER SCHOOL")

      assert_nil submitted
    end
>>>>>>> master
>>>>>>> 1a4468701af69f3f98020d3156b0f251807a099b

end
