require 'pry'
require_relative '../lib/clean_data'

class StatewideTest
  include CleanData

  def initialize(data)
    @name         = data[:name].upcase
    @third_grade  = clean_data(data[:third_grade])
    @eighth_grade = clean_data(data[:eighth_grade])
    @math         = clean_data(data[:math])
    @reading      = clean_data(data[:reading])
    @writing      = clean_data(data[:writing])
  end

  def proficient_by_grade(grade)
    raise UnknownDataError unless [3, 8].member?(grade)

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
