require 'pry'
require 'csv'
require_relative '../lib/enrollment_repository'
require_relative '../lib/district'
require_relative '../lib/enrollment'

class DistrictRepository
  attr_reader :districts, :enrollments, :enrollment_repo
  # attr_accessor :enrollment_repo

  def initialize
    @districts = []
    @enrollments = []
    @enrollment_repo = EnrollmentRepository.new
  end

  def parse_map
    {:enrollment => @enrollment_repo}
  end

  def load_data(data)
    dm = DataManager.new(data)
    districts = dm.all_districts

    districts.each do |district|
      @districts << District.new({name: district})
      @enrollments << Enrollment.new({name: district,
        kindergarten_participation: dm.kg_district_with_data.fetch(district),
        high_school_graduation: dm.hs_district_with_data.fetch(district)})
    end
    binding.pry
  end

  def create_repositories(data_hash)
    data_hash.each_key do |key|
      parse_map[key].load_data(data_hash)
    end
  end

  def parse_district_info(data_hash, key)
    data_hash[key].each_value { |value| create_districts(value) }
  end

  # def create_districts(file)
  #   # refactor to use unless?
  #   contents = CSV.open file, headers: true, header_converters: :symbol
  #   contents.each do |row|
  #     location = row[:location]
  #     @districts << District.new({name: location})
  #   end
  #   @districts.uniq! { |district| district.name }
  # end

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
