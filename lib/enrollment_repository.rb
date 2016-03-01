require 'pry'
require 'csv'

class EnrollmentRepository
  attr_reader :data

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
  end

end
