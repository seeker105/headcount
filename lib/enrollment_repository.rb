require 'pry'
require 'csv'

class EnrollmentRepository
  attr_reader :data, :enrollments

  def initialize(enrollments = [])
    @enrollments = enrollments
  end

  def load_data(data_hash)
    data_hash.each_value do |value|
      parse_loaded_data(value)
    end
  end

  def parse_loaded_data(data_hash)
    data_hash.each_value do |value|
      create_enrollments(value)
    end
  end

  def create_enrollments(file)
    # refactor to use unless?
    # enroll = Hash.new
    # kindergarten = Hash.new
    all = []

    contents = CSV.open file, headers: true, header_converters: :symbol
    contents.each do |row|
      # different processing for different files
      # create one name pointing to multiple years

      enroll = Hash.new
      kindergarten = Hash.new

      location = row[:location]
      enroll[:name] = location
      enroll[:kindergarten_participation] = kindergarten
      kindergarten[row[:timeframe].to_i] = row[:data].to_f

      # @enrollments << Enrollment.new({name: location})
      all << enroll
      @enrollments << Enrollment.new({name: location, :kindergarten_participation => kindergarten})
      # binding.pry
    end
    # binding.pry
  end

  # contents.group_by do |row|
  # => row[:location]
  # end
  # result.each_value do |csv_obj|
  # => kindergarten[row[:timeframe]] = row[:data]
  # end


  def find_by_name(name)
    @enrollments.find { |enrollment| enrollment.name == name.upcase }
  end

end
