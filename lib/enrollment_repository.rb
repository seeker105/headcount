require 'pry'
require 'csv'

class EnrollmentRepository
  attr_reader :data, :enrollments

  def initialize(enrollments = [])
    @enrollments = enrollments
  end

  def load_data(data_hash)
    data_hash.each_value do |value|
      create_enrollments(value)
    end
  end

  def create_enrollments(file)
    # refactor to use unless?
    contents = CSV.open file, headers: true, header_converters: :symbol
    contents.each do |row|
      # binding.pry
      location = row[:location]
      @enrollments << Enrollment.new({name: location})
    end
  end

  def find_by_name(name)
    @enrollments.find { |enrollment| enrollment.name == name.upcase }
  end

end
