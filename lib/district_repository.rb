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

  def populate_district_repo
    @districts = data_manager.all_districts
  end

  def find_by_name(name)
    districts.find { |district| district.name == name.upcase }
  end

  def find_all_matching(name)
    districts.select { |district| district.name.include?(name.upcase) }
  end

  def load_relationships
    districts.each do |district|
      district.enrollment = repo_connector(district, enrollment_repo)
      district.statewide_test = repo_connector(district, statewide_test_repo)
      district.economic_profile = repo_connector(district, economic_profile_repo)
    end
  end

  def repo_connector(district, repo)
    repo.find_by_name(district.name)
  end

end
