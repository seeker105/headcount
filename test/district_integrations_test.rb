require 'simplecov'
SimpleCov.start
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district_repository'
require_relative '../lib/enrollment_repository'
require_relative '../lib/district'
require_relative '../lib/enrollment'

class DistrictRepositoryIntegrationsTest < Minitest::Test

  @@district_repo  = DistrictRepository.new
  @@district_repo.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"},

    :statewide_testing => {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"},

    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"}
    })

  def district_repo_can_find_kindergarten_enrollment_participation_in_given_year
    district = @@district_repo.find_by_name("ACADEMY 20")
    submitted = district.enrollment.kindergarten_participation_in_year(2010)

    assert_equal 0.436, submitted
  end

  def test_statewide_test_repo_returns_nil_for_a_bad_name
    district = @@district_repo.find_by_name("ACADEMY 20")
    submitted = district.statewide_test

    assert_kind_of StatewideTest, submitted
  end

  def test_statewide_test_repo_finds_a_statewide_test_by_name
    name      = 'ACADEMY 20'
    submitted = @@district_repo.statewide_test_repo.find_by_name(name)

    assert_kind_of StatewideTest, submitted
    assert_equal name, submitted.name
  end

  def test_economic_profile

  end

end
