require 'simplecov'
SimpleCov.start
require_relative '../lib/enrollment_repository'
require_relative '../lib/district'
require_relative '../lib/enrollment'
require_relative '../lib/headcount_analyst'

class HeadcountRepositoryTest < Minitest::Test

  attr_accessor :analyst

  def setup
    @district_repo = DistrictRepository.new
    @analyst = HeadcountAnalyst.new(@district_repo)
  end

end
