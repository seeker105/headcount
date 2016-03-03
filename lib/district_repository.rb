require 'pry'
require 'csv'
require_relative '../lib/enrollment_repository'
require_relative '../lib/district'
require_relative '../lib/enrollment'
require_relative '../lib/data_manager'

class DistrictRepository
  attr_reader :districts, :data_manager, :enrollment_repo

  def initialize
    @data_manager = DataManager.new
    @enrollment_repo = EnrollmentRepository.new
  end

  def load_data(data)
    data_manager.load_data(data)
    populate_district_repo
    populate_enrollment_repo(data)
    # binding.pry
    load_enrollments
  end

  def load_relationships
    load_enrollments
  end

  def populate_district_repo
    @districts = data_manager.all_districts
  end

  def populate_enrollment_repo(data)
    @enrollment_repo.load_data(data)
  end

  def parse_district_info(data_hash, key)
    data_hash[key].each_value { |value| create_districts(value) }
  end

  def find_by_name(name)
    @districts.find { |district| district.name == name.upcase }
  end

  def find_all_matching(name)
    @districts.select { |district| district.name.include?(name.upcase) }
  end

  def load_enrollments
    @districts.each do |district|
      district.enrollment = @enrollment_repo.find_by_name(district.name)
    end
  end

end
