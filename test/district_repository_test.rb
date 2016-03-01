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
    district_1    = District.new({name: "New York"})
    district_repo = DistrictRepository.new([district_1])

    submitted = district_repo.find_all_matching("New York")
    expected  = [district_1]

    assert_equal expected, submitted
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

  def test_load_can_accept_hash
    skip
    @district_repo.load_data({enrollment: {
                              kindergarten: "./data/Kindergartners in full-day program.csv"}
                             })


  end

end
