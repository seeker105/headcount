require 'pry'
require 'csv'

class DistrictRepository
  attr_reader :districts, :enrollments

  def initialize(districts = [])
    @districts = districts
  end

  def find_by_name(name)
    @districts.find { |district| district.name == name.upcase }
  end

  def find_all_matching(name)
    @districts.select { |district| district.name.include?(name.upcase) }
  end

  def load_enrollments(enrollments)
    @districts.each do |district|
      district.enrollment = enrollments.find_by_name(district.name)
    end
  end

end
