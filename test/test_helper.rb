require_relative '../lib/district_repository'
require_relative '../lib/headcount_analyst'

module TestHelper

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

  @@enrollment_repo       = @@district_repo.enrollment_repo
  @@stw_test_repo         = @@district_repo.statewide_test_repo
  @@economic_profile_repo = @@district_repo.economic_profile_repo

  @@headcount_analyst     = HeadcountAnalyst.new(@@district_repo)

  @@district              = @@district_repo.find_by_name('academy 20')

end
