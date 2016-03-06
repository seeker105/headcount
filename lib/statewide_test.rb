require 'pry'
require_relative '../lib/clean_data'
require_relative '../lib/custom_errors'
require_relative '../lib/statewide_categories'

class StatewideTest
  include CleanData
  include StatewideCategories

  attr_reader :name, :third_grade, :eighth_grade,
              :math, :reading, :writing

  def initialize(data)
    @name         = data[:name].upcase
    @third_grade  = data[:third_grade]
    @eighth_grade = data[:eighth_grade]

    @math         = data[:math]
    @reading      = data[:reading]
    @writing      = data[:writing]

    @subjects = [math, reading, writing]
  end

  def proficient_by_grade(grade)
    raise UnknownDataError unless GRADE.member?(grade)
    case grade
    when 3 then third_grade
    when 8 then eighth_grade
    end
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownRaceError unless RACES.member?(race)
    math    = create_year_subject_data_hash(@math, race, :math)
    reading = create_year_subject_data_hash(@reading, race, :reading)
    writing = create_year_subject_data_hash(@writing, race, :writing)
    math.each_key.with_object({}) do |key, result|
      result[key] = (math[key].merge(reading[key])).merge(writing[key])
    end
  end

  def create_year_subject_data_hash(var, race, symbol)
    var.fetch(race).each_with_object([]) do |(k, v), array|
      array << [k, {symbol => v}]
    end.to_h
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    raise UnknownDataError unless SUBJECTS.member?(subject)
    pct = proficient_by_grade(grade).fetch(year).fetch(subject)
    pct == 0.0 ? "N/A" : pct
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    raise UnknownDataError unless RACES.member?(race)
    raise UnknownDataError unless SUBJECTS.member?(subject)
    proficient_by_race_or_ethnicity(race).fetch(year).fetch(subject)
  end

end
