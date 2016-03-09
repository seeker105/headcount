<<<<<<< HEAD
require 'simplecov'
SimpleCov.start
=======
>>>>>>> master
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district_repository'
<<<<<<< HEAD
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

  def test_kindergarten_participation_correlates_with_high_school_graduation
    # skip
    array     = ['ACADEMY 20', 'AGATE 300', 'CHERAW 31']
    submitted = @h_analyst.kindergarten_participation_correlates_with_high_school_graduation(across: array)

    refute submitted
=======
require_relative '../lib/headcount_analyst'

class HeadcountRepositoryTest < Minitest::Test

  attr_accessor :analyst

  def setup
    @district_repo = DistrictRepository.new
    @analyst = HeadcountAnalyst.new(@district_repo)
  end

  def test_it_can_create_a_new_headcount_analyst
    test_district_repo = DistrictRepository.new
    assert test_analyst = HeadcountAnalyst.new(test_district_repo)
  end

  def test_it_calculates_the_kindergarten_participation_rate_against_state
    submitted = analyst.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    expected = 0.668
    assert_equal expected, submitted
  end

  def test_it_calculates_the_kindergarten_participation_rate_against_another_district
    submitted = analyst.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'GREEN MOUNTAIN')
    expected = 0.510
    assert_equal expected, submitted
  end

  def test_it_calculates_a_hash_of_comparisons_to_state_by_year
    submitted = analyst.kindergarten_participation_rate_variation_trend("ACADEMY 20", :against => "COLORADO")
    expected = {2010 => 0.909,
                2011 => 0.460,
                2012 => 0.856}
    assert_equal expected, submitted
  end

  def test_it_calculates_a_hash_of_comparisons_to_another_district_by_year
    submitted = analyst.kindergarten_participation_rate_variation_trend("ACADEMY 20", :against => "GREEN MOUNTAIN")
    expected = {2010 => 0.658,
                2011 => 0.432,
                2012 => 0.472}
    assert_equal expected, submitted
  end

  def test_kindergarten_participation_against_high_school_graduation_returns_the_correct_value
    submitted = kindergarten_participation_against_high_school_graduation('ACADEMY 20')
>>>>>>> master
  end

end
