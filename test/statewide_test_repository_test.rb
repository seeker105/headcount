require 'simplecov'
SimpleCov.start
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/data_manager'
require_relative '../lib/statewide_test_repository'
require_relative '../lib/statewide_test'

class StatewideTestRepositoryTest < Minitest::Test

  def setup
    @stw_test_repo = StatewideTestRepository.new
    # @stw_test_repo.load_data({ :statewide_testing => {
    #   :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
    #   :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    #   :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    #   :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    #   :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv" }
    #   })
    @stw_test_repo.load_data({ :statewide_testing => {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"}
      })
  end

  def test_can_create_statewide_test_repo
    # skip
    assert_kind_of StatewideTestRepository, @stw_test_repo
  end


end
