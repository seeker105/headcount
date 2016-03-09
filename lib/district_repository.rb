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
    populate_district_repo(data_manager.all_districts)
    data.each_key { |key| load_map[key].load_data({key => data[key]}) }
    load_relationships
  end

  def populate_district_repo(raw_districts)
    @districts = raw_districts.each_with_object({}) do |district, object|
      object[district.name] = district
    end
  end

  def find_by_name(name)
    districts[name.upcase]
  end

  def find_all_matching(name)
    districts.each_with_object([]) do |district, object|
      object << district.last if district.first.include?(name)
    end
  end

  def load_relationships
    districts.each_value do |district|
      district.enrollment       = repo_connect(district, enrollment_repo)
      district.statewide_test   = repo_connect(district, statewide_test_repo)
      district.economic_profile = repo_connect(district, economic_profile_repo)
    end
  end

  def repo_connect(district, repo)
    repo.find_by_name(district.name)
  end

  def kd_participation_avg_all_yrs(name)
    find_by_name(name).enrollment.kd_participation_avg_all_yrs
  end

  def graduation_avg_all_years(name)
    find_by_name(name).enrollment.graduation_avg_all_years
  end

end
