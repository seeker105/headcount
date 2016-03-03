require 'pry'
require 'csv'
require_relative '../lib/enrollment'

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
      parse_csv_data(value)
    end
  end

  def parse_csv_data(file)
    contents = CSV.open file, headers: true, header_converters: :symbol
    contents.each do |row|
      district = row[:location]
      year_and_percentage = { row[:timeframe].to_i => row[:data].to_f }
      create_enrollments(file, district, year_and_percentage)
    end
  end

  def create_enrollments(file, district, year_and_percentage)
    # binding.pry
    if file.include?('Kindergartners')
      a1 = :kindergarten_participation
      a2 = :high_school_graduation
    else
      a1 = :high_school_graduation
      a2 = :kindergarten_participation
    end


    if find_by_name(district).nil?
      @enrollments << Enrollment.new({name: district,
        a1 => year_and_percentage,
        a2 => {}})
    else
      match = find_by_name(district)

      if a1 == :kindergarten_participation
        match.kindergarten_participation.merge!(clean_data(year_and_percentage))
      else
        match.high_school_graduation.merge!(clean_data(year_and_percentage))
      end

    end
  end

  def clean_data(data)
    return data if data.nil?
    data.each_pair { |year, pct| data[year] = format_percentage(pct) }
  end

  def format_percentage(pct)
    case pct
    when Float then (pct * 1000).floor / 1000.0
    when Fixnum then pct.to_f
    else "bad percentage data"
    end
  end

  def find_by_name(name)
    @enrollments.find { |enrollment| enrollment.name == name.upcase }
  end

end
