require_relative './test_helper'

class StatewideTestRepositoryTest < Minitest::Test
  include TestHelper

  def test_can_create_statewide_test_repo
    assert_kind_of StatewideTestRepository, @@stw_test_repo
  end

  def test_statewide_test_repo_finds_a_statewide_test_by_name
    name      = 'ACADEMY 20'
    submitted = @@stw_test_repo.find_by_name(name)

    assert_kind_of StatewideTest, submitted
    assert_equal name, submitted.name
  end

  def test_statewide_test_repo_finds_a_statewide_test_by_name
    name      = 'this is absolutely not a repo'
    submitted = @@stw_test_repo.find_by_name(name)

    assert_nil submitted
  end

  def test_repo_can_load_data
    repo = StatewideTestRepository.new

    assert_empty repo.statewide_tests

    submitted = repo.load_data({ statewide_testing: {
      third_grade: "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      eighth_grade: "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      math: "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      reading: "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      writing: "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"}})

    assert_equal 181, repo.statewide_tests.count
  end

end
