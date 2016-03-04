require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district_repository'
require_relative '../lib/enrollment_repository'
require_relative '../lib/district'
require_relative '../lib/enrollment'
require_relative '../lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def setup
    # skip
    district_repo  = DistrictRepository.new
    district_repo.load_data(:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"})

    @h_analyst      = HeadcountAnalyst.new(district_repo)
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

  def test_it_returns_the_kindergarten_participation_rate_variation_trend
    skip
    submitted = @h_analyst.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
    expected  = {2010=>0.611, 2011=>0.525, 2012=>0.384}

    assert_equal expected, submitted
  end

end
