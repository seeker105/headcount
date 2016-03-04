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

  def test_district_can_process_enrollment_with_two_csvs
    # skip
    district_repo  = DistrictRepository.new
    district_repo.load_data(:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"})

    submitted = district_repo.find_by_name("ACADEMY 20")

    assert_equal 0.436, submitted.enrollment.kindergarten_participation_in_year(2010)
  end



end
