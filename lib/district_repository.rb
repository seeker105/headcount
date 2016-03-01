require 'pry'
require 'csv'

class DistrictRepository
  attr_reader :districts, :enrollments

  def initialize(districts = [])
    @districts = districts
  end

  def find_district_by_name(name)
    # returns nil or district object
    @districts.find do |district|
      district.name = name.upcase
    end
  end

  def find_all_matching(name)
    @districts.select do |district|
      district.name.include?(name.upcase)
    end
  end

  def load_enrollments(enrollments)
    @districts.each do |district|
      district.enrollment = enrollments.find_by_name(district.name)
    end
  end

end
