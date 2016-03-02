require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district_repository'
require_relative '../lib/district'

class DistrictRepositoryTest < Minitest::Test

  def setup
    @district_repo = DistrictRepository.new
  end

  def test_can_create_enrollment_repo_object
    assert_kind_of DistrictRepository, @district_repo
  end

  def test_can_find_district_by_name
    district_1    = District.new({name: "New York"})
    district_repo = DistrictRepository.new([district_1])

    submitted = district_repo.find_by_name("New York")
    expected  = district_1

    assert_equal expected, submitted
  end

  def test_can_find_district_by_name_returns_nil_with_no_match
    district_1    = District.new({name: "New York"})
    district_repo = DistrictRepository.new([district_1])

    submitted = district_repo.find_by_name("Colorado")
    expected  = district_1

    assert_nil submitted
  end

  def test_can_find_multiple_matching_districts
    district_1 = District.new({name: "New York"})
    district_2 = District.new({name: "New Hampsire"})
    district_3 = District.new({name: "Canada"})

    district_repo = DistrictRepository.new([ district_1,
                                             district_2,
                                             district_3 ])

    submitted = district_repo.find_all_matching("New")
    expected  = [district_1, district_2]

    assert_kind_of Array, submitted
    assert_equal expected, submitted
  end

  def test_returns_empty_array_if_no_matching_names
    district_1 = District.new({name: "New York"})
    district_2 = District.new({name: "New Hampsire"})
    district_3 = District.new({name: "Canada"})

    district_repo = DistrictRepository.new([ district_1,
                                             district_2,
                                             district_3 ])

    submitted = district_repo.find_all_matching("Colorado")

    assert_kind_of Array, submitted
    assert_empty submitted
  end

  def test_repo_can_load_data_from_csv_file
    # skip
    dist_repo = DistrictRepository.new
    dist_repo.load_data({ :enrollment => { :kindergarten => "./data/Kindergartners in full-day program.csv"}})

    submitted = dist_repo.districts.count
    expected = 181

    assert_equal expected, submitted
  end

  def test_district_repo_auto_creates_enrollment
    skip
    dist_repo = DistrictRepository.new
    dist_repo.load_data({ :enrollment => { :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    dist_repo.load_enrollments

    district  = dist_repo.find_by_name("ACADEMY 20")
    binding.pry
    submitted = district.enrollment.kindergarten_participation_in_year(2010)
    expected  = 0.391

    assert_equal expected, submitted
  end


end
