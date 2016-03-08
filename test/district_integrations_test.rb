require 'simplecov'
SimpleCov.start
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative './test_helper'
require_relative '../lib/district_repository'
require_relative '../lib/enrollment_repository'
require_relative '../lib/district'
require_relative '../lib/enrollment'

class DistrictRepositoryIntegrationsTest < Minitest::Test
  include TestHelper

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
    skip
    # binding.pry

  end

  def test_enrollment_returns_the_correct_enrollment_object
    name                       = "ACADEMY 20"
    kindergarten_participation = { 2007=>0.391, 2006=>0.353, 2005=>0.267,
                                   2004=>0.302, 2008=>0.384, 2009=>0.39,
                                   2010=>0.436, 2011=>0.489, 2012=>0.478,
                                   2013=>0.487, 2014=>0.49
                                 }
    high_school_graduation     = { 2010=>0.895, 2011=>0.895, 2012=>0.889,
                                   2013=>0.913, 2014=>0.898
                                 }
    submitted                    = @@district.enrollment

    assert_kind_of Enrollment, submitted
    assert_equal name, submitted.name
    assert_equal kindergarten_participation, submitted.kindergarten_participation
    assert_equal high_school_graduation, submitted.high_school_graduation
  end

  def test_statewide_test_returns_the_correct_statewide_test_object
    name         = "ACADEMY 20"
    third_grade  = {
                     2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671},
                     2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706},
                     2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662},
                     2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678},
                     2012=>{:reading=>0.87, :math=>0.83, :writing=>0.655},
                     2013=>{:math=>0.855, :reading=>0.859, :writing=>0.668},
                     2014=>{:math=>0.834, :reading=>0.831, :writing=>0.639}
                   }
    eighth_grade = {
                     2008=>{:math=>0.64, :reading=>0.843, :writing=>0.734},
                     2009=>{:math=>0.656, :reading=>0.825, :writing=>0.701},
                     2010=>{:math=>0.672, :reading=>0.863, :writing=>0.754},
                     2011=>{:reading=>0.832, :math=>0.653, :writing=>0.745},
                     2012=>{:math=>0.681, :writing=>0.738, :reading=>0.833},
                     2013=>{:math=>0.661, :reading=>0.852, :writing=>0.75},
                     2014=>{:math=>0.684, :reading=>0.827, :writing=>0.747}
                   }
    math         = {
                     :all_students=>{2011=>0.68, 2012=>0.689, 2013=>0.696, 2014=>0.699},
                     :asian=>{2011=>0.816, 2012=>0.818, 2013=>0.805, 2014=>0.8},
                     :black=>{2011=>0.424, 2012=>0.424, 2013=>0.44, 2014=>0.42},
                     :pacific_islander=>{2011=>0.568, 2012=>0.571, 2013=>0.683, 2014=>0.681},
                     :hispanic=>{2011=>0.568, 2012=>0.572, 2013=>0.588, 2014=>0.604},
                     :native_american=>{2011=>0.614, 2012=>0.571, 2013=>0.593, 2014=>0.543},
                     :two_or_more=>{2011=>0.677, 2012=>0.689, 2013=>0.696, 2014=>0.693},
                     :white=>{2011=>0.706, 2012=>0.713, 2013=>0.72, 2014=>0.723}
                   }
    reading      = {
                     :all_students=>{2011=>0.83, 2012=>0.845, 2013=>0.845, 2014=>0.841},
                     :asian=>{2011=>0.897, 2012=>0.893, 2013=>0.901, 2014=>0.855},
                     :black=>{2011=>0.662, 2012=>0.694, 2013=>0.669, 2014=>0.703},
                     :pacific_islander=>{2011=>0.745, 2012=>0.833, 2013=>0.866, 2014=>0.931},
                     :hispanic=>{2011=>0.748, 2012=>0.771, 2013=>0.772, 2014=>0.007},
                     :native_american=>{2011=>0.816, 2012=>0.785, 2013=>0.813, 2014=>0.007},
                     :two_or_more=>{2011=>0.841, 2012=>0.845, 2013=>0.855, 2014=>0.008},
                     :white=>{2011=>0.851, 2012=>0.861, 2013=>0.86, 2014=>0.008}
                   }
    writing      = {
                     :all_students=>{2011=>0.719, 2012=>0.705, 2013=>0.72, 2014=>0.715},
                     :asian=>{2011=>0.826, 2012=>0.808, 2013=>0.81, 2014=>0.789},
                     :black=>{2011=>0.515, 2012=>0.504, 2013=>0.481, 2014=>0.519},
                     :pacific_islander=>{2011=>0.725, 2012=>0.683, 2013=>0.716, 2014=>0.727},
                     :hispanic=>{2011=>0.606, 2012=>0.597, 2013=>0.623, 2014=>0.624},
                     :native_american=>{2011=>0.6, 2012=>0.589, 2013=>0.61, 2014=>0.62},
                     :two_or_more=>{2011=>0.727, 2012=>0.718, 2013=>0.747, 2014=>0.731},
                     :white=>{2011=>0.74, 2012=>0.726, 2013=>0.74, 2014=>0.734}
                   }

    submitted = @@district.statewide_test

    assert_kind_of StatewideTest, submitted
    assert_equal name,            submitted.name
    assert_equal third_grade,     submitted.third_grade
    assert_equal eighth_grade,    submitted.eighth_grade
    assert_equal math,            submitted.math
    assert_equal reading,         submitted.reading
    assert_equal writing,         submitted.writing
  end

end
