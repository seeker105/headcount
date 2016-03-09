require 'simplecov'
SimpleCov.start
require_relative '../lib/enrollment_repository'
require_relative '../lib/district'
require_relative '../lib/enrollment'
require_relative '../lib/headcount_analyst'
require_relative '../lib/custom_errors'

class HeadcountRepositoryTest < Minitest::Test

  attr_accessor :analyst

  def setup
    @district_repo = DistrictRepository.new.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv",
                   },
                   :statewide_testing => {
                     :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                     :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                     :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                     :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                     :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                   }
                 })
    @h_analyst = HeadcountAnalyst.new(@district_repo)
  end

  def test_it_can_initialize_with_a_new_district_repository
    # skip
    assert_kind_of HeadcountAnalyst, @h_analyst
  end

  def test_it_returns_the_kindergarten_participation_rate_variation_with_state_avg
    # skip
    submitted = @h_analyst.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    expected  = 0.766

    assert_equal expected, submitted
  end

  def test_it_returns_the_kindergarten_participation_rate_variation
    # skip
    submitted = @h_analyst.kindergarten_participation_rate_variation("GUNNISON WATERSHED RE1J", :against => "TELLURIDE R-1")
    expected  = 1.126

    assert_equal expected, submitted
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_single
    submitted = @h_analyst.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')

    assert submitted
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_statewide
    submitted = @h_analyst.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')

    refute submitted
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation
    # skip
    array     = ['ACADEMY 20', 'AGATE 300', 'CHERAW 31']
    submitted = @h_analyst.kindergarten_participation_correlates_with_high_school_graduation(across: array)

    refute submitted
  end

end
