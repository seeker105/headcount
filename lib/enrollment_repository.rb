require 'pry'
require 'csv'

class EnrollmentRepository
  attr_reader :data, :enrollments

  def initialize(enrollments = [])
    @enrollments = enrollments
  end

  def load_data(data)
    data.fetch(:enrollment).each do |key, value|
      csv_file = CSV.open value, headers: true, header_converters: :symbol
      csv_file.each do |row|
        location = row[:location]
      end
    end
  end

  def find_by_name(name)
    # case insensitive search
    # returns enrollment object
    # else returns nil
    @enrollments.find do |enrollment|
      enrollment.name = name.upcase
    end
  end

end
