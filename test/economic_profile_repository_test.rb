require_relative './test_helper'

class EconomicProfileRepositoryTest < Minitest::Test
  include TestHelper

  def test_repo_is_enrollment_profile_repo_object
    assert_kind_of EconomicProfileRepository, @@economic_profile_repo
  end

  def test_repo_can_find_economic_profile_by_name
    submitted = @@economic_profile_repo.find_by_name("ACADEMY 20")
    expected  = {
                  2009 => 0.014, 2011 => 0.011, 2012 => 0.01,
                  2013 => 0.012, 2014 => 0.027
                }

    assert_kind_of EconomicProfile, submitted
    assert_equal expected, submitted.title_i
  end

  def test_repo_find_by_name_returns_nil_if_no_match
    submitted = @@economic_profile_repo.find_by_name("NOT A REPO")

    assert_nil submitted
  end

  def test_repo_can_load_data
    repo = EconomicProfileRepository.new

    assert_empty repo.economic_profiles

    submitted = repo.load_data({ economic_profile: {
      median_household_income: "./data/Median household income.csv",
      children_in_poverty: "./data/School-aged children in poverty.csv",
      free_or_reduced_price_lunch: "./data/Students qualifying for free or reduced price lunch.csv",
      title_i: "./data/Title I students.csv"} })

    assert_equal 181, repo.economic_profiles.count
  end

end
