<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 1a4468701af69f3f98020d3156b0f251807a099b
require 'simplecov'
SimpleCov.start
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

  def test_find_by_name_returns_district
    # skip
    district_1    = District.new({name: "New York"})
    district_repo = DistrictRepository.new
    district_repo.districts << district_1

    submitted = district_repo.find_by_name("New York")
    expected  = district_1

    assert_equal expected, submitted
  end

  def test_find_by_name_returns_nil_with_no_match
    # skip
    district_1    = District.new({name: "New York"})
    district_repo = DistrictRepository.new
    district_repo.districts << district_1

    submitted = district_repo.find_by_name("Colorado")
    expected  = district_1

    assert_nil submitted
  end

  def test_find_all_by_matching_returns_array_of_potential_matches
    # skip
    district_1 = District.new({name: "New York"})
    district_2 = District.new({name: "New Hampsire"})
    district_3 = District.new({name: "Canada"})
    district_repo = DistrictRepository.new

    district_repo.districts << district_1
    district_repo.districts << district_2
    district_repo.districts << district_3

    submitted = district_repo.find_all_matching("New")
    expected  = [district_1, district_2]

    assert_kind_of Array, submitted
    assert_equal expected, submitted
  end

  def test_find_all_by_matching_returns_empty_array_if_no_matches
    # skip
    district_1 = District.new({name: "New York"})
    district_2 = District.new({name: "New Hampsire"})
    district_3 = District.new({name: "Canada"})
    district_repo = DistrictRepository.new

    district_repo.districts << district_1
    district_repo.districts << district_2
    district_repo.districts << district_3

    submitted = district_repo.find_all_matching("Georgia")

    assert_kind_of Array, submitted
    assert_empty submitted
  end

  def test_district_repo_can_search_enrollment_repo_insensitive_search
    # skip
    district_repo = DistrictRepository.new
    district_repo.load_data(:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"})

    district  = district_repo.find_by_name("academy 20")

    submitted = district.enrollment.kindergarten_participation_in_year(2010)
    expected  = 0.436

    assert_equal expected, submitted
  end

  def test_district_repo_can_access_enrollment_methods_through_district
    # skip
    district_repo = DistrictRepository.new
    district_repo.load_data({:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"}})

    district = district_repo.find_by_name("GUNNISON WATERSHED RE1J")

    submitted = district.enrollment.kindergarten_participation_in_year(2004)
    expected  = 0.144

    assert_equal expected, submitted
  end

<<<<<<< HEAD
=======
=======
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district'
require_relative '../lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_find_by_name_returns_nil_if_it_finds_no_matches
    dr = DistrictRepository.new
    submitted = dr.find_by_name("ACADEMY 20")
    expected  = nil
    assert_equal expected, submitted
  end

  def test_find_by_name_returns_an_instance_of_District
    district = District.new({:name => "ACADEMY 20"})
    district_repo = DistrictRepository.new
    district_repo.districts << district
    submitted = district_repo.find_by_name("ACADEMY 20")
    expected  = district
    assert_equal expected, submitted
  end

  def test_find_by_name_returns_an_instance_of_District_case_insensitive
    district = District.new({:name => "ACADEMY 20"})
    district_repo = DistrictRepository.new
    district_repo.districts << district
    submitted = district_repo.find_by_name("academy 20")
    expected  = district
    assert_equal expected, submitted

    district = District.new({:name => "ACADEMY 20"})
    district_repo = DistrictRepository.new
    district_repo.districts << district
    submitted = district_repo.find_by_name("acADemy 20")
    expected  = district
    assert_equal expected, submitted
  end

  def test_find_all_matching_returns_nil_array_if_no_matches_on_an_empty_array
    dr = DistrictRepository.new
    submitted = dr.find_all_matching("ACADEMY 20")
    expected  = []
    assert_equal expected, submitted
  end

  def test_find_all_matching_returns_nil_array_if_no_matches_on_a_non_empty_array
    district  = District.new({:name => "ACADEMY 20"})
    district_repo = DistrictRepository.new
    district_repo.districts << district
    submitted = district_repo.find_all_matching("Colorado")
    expected  = []
    assert_equal expected, submitted
  end

  def test_find_all_matching_returns_a_single_item_array_if_one_match
    district = District.new({:name => "ACADEMY 20"})
    district_repo = DistrictRepository.new
    district_repo.districts << district
    submitted = district_repo.find_all_matching("ACADEMY 20")
    expected  = [district]
    assert_equal expected, submitted
  end

  def test_find_all_matching_returns_a_single_item_array_if_one_match_using_a_name_fragment
    district = District.new({:name => "ACADEMY 20"})
    district_repo = DistrictRepository.new
    district_repo.districts << district
    submitted = district_repo.find_all_matching("ACAD")
    expected  = [district]
    assert_equal expected, submitted

    # more than 1 item in the array
    district2 = District.new({:name => "Colorado"})
    district_repo.districts << district2
    submitted = district_repo.find_all_matching("ACAD")
    expected  = [district]
    assert_equal expected, submitted

    # case insensitive name fragment
    submitted = district_repo.find_all_matching("caDEm")
    expected  = [district]
    assert_equal expected, submitted
  end

  def test_find_all_matching_returns_a_2_item_array_if_2_matches
    district = District.new({:name => "ACADEMY 20"})
    district2 = District.new({:name => "COLORADO WEST"})
    district3 = District.new({:name => "COLORADO EAST"})
    district4 = District.new({:name => "LEADVILLE"})
    district_repo = DistrictRepository.new
    district_repo.districts << district
    district_repo.districts << district2
    district_repo.districts << district3
    district_repo.districts << district4
    submitted = district_repo.find_all_matching("Colorado")
    expected  = [district2, district3]
    assert_equal expected, submitted
  end

  def test_find_all_matching_returns_a_multi_item_array_if_multiple_matches
    district = District.new({:name => "ACADEMY 20"})
    district2 = District.new({:name => "COLORADO WEST"})
    district3 = District.new({:name => "COLORADO EAST"})
    district4 = District.new({:name => "LEADVILLE"})
    district5 = District.new({:name => "GREEN MOUNTAIN"})
    district_repo = DistrictRepository.new
    district_repo.districts << district
    district_repo.districts << district2
    district_repo.districts << district3
    district_repo.districts << district4
    district_repo.districts << district5
    submitted = district_repo.find_all_matching("ad")
    expected  = [district, district2, district3, district4]
    assert_equal expected, submitted
  end


>>>>>>> master
>>>>>>> 1a4468701af69f3f98020d3156b0f251807a099b
end
