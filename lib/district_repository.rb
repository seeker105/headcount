require 'pry'
require 'csv'

class DistrictRepository
  attr_reader :districts, :enrollments

  def initialize(districts = [])
    @districts = districts
  end

  def parse_map
    {:enrollment => EnrollmentRepository}
  end

  # def load_data(data_hash)
  #   # => create relevant repositories
  #   # data_hash.each_key do |key|
  #   #   parse_map[key].load_data(data_hash[key])
  #   # end
  #
  #   # create uniq district objects
  #   data_hash.each_key do |key|
  #     data_hash[key].each_value do |value|
  #       create_districts(value)
  #     end
  #   end
  #   binding.pry
  # end

  def load_data(data_hash)
    data_hash.each_key do |key|
      parse_district_info(data_hash, key)
      # create_repositories(data_hash)
    end
  end

  def create_repositories(data_hash)
    data_hash.each_key do |key|
      parse_map[key].new.load_data(data_hash[key])
    end
  end

  def parse_district_info(data_hash, key)
    data_hash[key].each_value { |value| create_districts(value) }
  end

  def create_districts(file)
    # refactor to use unless?
    contents = CSV.open file, headers: true, header_converters: :symbol
    contents.each do |row|
      location = row[:location]
      @districts << District.new({name: location})
    end
    @districts.uniq! { |district| district.name }
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
