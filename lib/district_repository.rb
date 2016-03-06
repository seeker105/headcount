require 'pry'
require_relative '../lib/data_manager'
require_relative '../lib/enrollment_repository'
require_relative '../lib/statewide_test_repository'
require_relative '../lib/economic_profile_repository'

class DistrictRepository
  attr_accessor :districts
  attr_reader   :data_manager, :enrollment_repo,
                :statewide_test_repo, :economic_profile_repo

  def initialize
    @districts             = []
    @data_manager          = DataManager.new
    @enrollment_repo       = EnrollmentRepository.new
    @statewide_test_repo   = StatewideTestRepository.new
    @economic_profile_repo = EconomicProfileRepository.new
  end

  def load_map
    {enrollment: enrollment_repo,
     statewide_testing: statewide_test_repo,
     economic_profile: economic_profile_repo}
  end

  def load_data(data)
    data_manager.load_data(data)
    populate_district_repo
    data.each_key { |key| load_map[key].load_data({key => data[key]}) }
    load_relationships
  end

  def load_relationships
    load_enrollments
    load_statewide_tests
  end

  def populate_district_repo
    @districts = data_manager.all_districts
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

  def load_statewide_tests
    @districts.each do |district|
      district.statewide_test = @statewide_test_repo.find_by_name(district.name)
    end
  end

end
