require 'pry'
require_relative '../lib/clean_data'
require_relative '../lib/custom_errors'

class StatewideTest
  include CleanData

  GRADE    = [3, 8]
  SUBJECTS = [:math, :reading, :writing]
  RACES    = [:asian, :black, :pacific_islander,
              :hispanic, :native_american, :two_or_more,
              :white]

  def initialize(data)
    @name         = data[:name].upcase
    @third_grade  = data[:third_grade]
    @eighth_grade = data[:eighth_grade]
    @math         = data[:math]
    @reading      = data[:reading]
    @writing      = data[:writing]
  end

  def proficient_by_grade(grade)
    raise UnknownDataError unless GRADE.member?(grade)
    case grade
    when 3
      @third_grade
    when 8
      @eighth_grade
    end
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownRaceError unless RACES.member?(race)
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    raise UnknownDataError unless SUBJECTS.member?(subject)
    raise UnknownDataError unless GRADE.member?(grade)

  end

  # def kindergarten_participation_by_year
  #   kindergarten_participation
  # end
  #
  # def kindergarten_participation_in_year(year)
  #   if contains_year?(year, kindergarten_participation)
  #     kindergarten_participation.fetch(year)
  #   end
  # end
  #
  # def contains_year?(year, group)
  #   raise ArgumentError unless year.is_a? Fixnum
  #   group.has_key?(year)
  # end
  #
  # def kd_participation_avg_all_yrs
  #   compute_avg(kindergarten_participation.values)
  # end
  #
  # def graduation_rate_by_year
  #   high_school_graduation
  # end
  #
  # def graduation_avg_all_years
  #   compute_avg(high_school_graduation.values)
  # end
  #
  # def compute_avg(array)
  #   array.reduce(:+) / array.count
  # end
  #
  # def graduation_rate_in_year(year)
  #   if contains_year?(year, high_school_graduation)
  #     high_school_graduation.fetch(year)
  #   end
  # end

end
