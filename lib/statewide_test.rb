require 'pry'
require_relative '../lib/clean_data'
require_relative '../lib/custom_errors'

class StatewideTest
  include CleanData

  attr_reader :name, :third_grade, :eighth_grade,
              :math, :reading, :writing

  GRADE    = [3, 8]
  # SUBJECTS = [:math, :reading, :writing]
  RACES    = [:asian, :black, :pacific_islander,
              :hispanic, :native_american, :two_or_more,
              :white]

  def initialize(data)
    # @data         = data
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
    # math = @math.fetch(race)
    # math.each_with_object([]) { |(k, v), array| array << [k, {math: v}] }.to_h
    math = @math.fetch(race).each_with_object([]) { |(k, v), array| array << [k, {math: v}] }.to_h
    reading = @reading.fetch(race).each_with_object([]) { |(k, v), array| array << [k, {reading: v}] }.to_h
    writing = @writing.fetch(race).each_with_object([]) { |(k, v), array| array << [k, {writing: v}] }.to_h

    result = {}
    math.each_key do |key|
      result[key] = (math[key].merge(reading[key])).merge(writing[key])
    end
    result
    # binding.pry

  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    raise UnknownDataError unless SUBJECTS.member?(subject)
    raise UnknownDataError unless GRADE.member?(grade)

  end

end
