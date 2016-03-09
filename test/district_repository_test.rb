require_relative './test_helper'

class DistrictRepositoryTest < Minitest::Test
  include TestHelper

  def test_can_create_enrollment_repo_object
    assert_kind_of DistrictRepository, @@district_repo
  end

  def test_find_by_name_returns_district
    # skip
    submitted = @@district_repo.find_by_name("ACADEMY 20")

    assert_kind_of District, submitted
    assert_equal 'ACADEMY 20', submitted.name
  end

  def test_find_by_name_returns_nil_with_no_match
    # skip
    submitted = @@district_repo.find_by_name("MEGA SCHOOL")

    assert_nil submitted
  end

  def test_find_all_by_matching_returns_array_of_potential_matches
    # skip
    submitted = @@district_repo.find_all_matching("BRI")
    expected  = 2

    assert_kind_of Array, submitted
    assert_equal expected, submitted.count
  end

  def test_find_all_by_matching_returns_empty_array_if_no_matches
    submitted = @@district_repo.find_all_matching("Georgia")

    assert_kind_of Array, submitted
    assert_empty submitted
  end

  def test_district_repo_can_search_enrollment_repo_insensitive_search
    # skip
    district  = @@district_repo.find_by_name("academy 20")

    submitted = district.enrollment.kindergarten_participation_in_year(2010)
    expected  = 0.436

    assert_equal expected, submitted
  end

  def test_district_repo_can_access_enrollment_methods_through_district
    # skip
    district = @@district_repo.find_by_name("GUNNISON WATERSHED RE1J")

    submitted = district.enrollment.kindergarten_participation_in_year(2004)
    expected  = 0.144

    assert_equal expected, submitted
  end

  def test_kd_participation_avg_all_yrs_returns_avg
    submitted = @@district_repo.kd_participation_avg_all_yrs("ACADEMY 20")
    expected  = 0.406

    assert_equal expected, submitted.round(3)
  end

  def test_graduation_average_all_yrs_returns_avg
    submitted = @@district_repo.graduation_avg_all_years("ACADEMY 20")
    expected  = 0.898

    assert_equal expected, submitted
  end

end
