require 'pry'
require 'csv'
require_relative '../lib/district_repository'
require_relative '../lib/enrollment_repository'
require_relative '../lib/district'
require_relative '../lib/enrollment'

require_relative '../lib/clean_data'


class DataManager
  include CleanData

  attr_reader :all_districts, :all_enrollments, :kg_district_with_data, :hs_district_with_data

  def initialize
    @all_districts = []
    @all_enrollments = []
    @kg_district_with_data = {}
    @hs_district_with_data = {}
  end

  def load_data(data_hash)
    data_hash.each_value do |value|
      # enrollment route vs statewide route
      parse_loaded_data(value)
    end
  end

  def parse_loaded_data(data_hash)
    data_hash.each_value do |value|
      parse_csv_data(value)
    end
  end

  # def parse_loaded_data(data_hash)
  #   data_hash.each_pair do |key, value|
  #     parse_csv_data(value)
  #   end
  # end

  def parse_csv_data(file)
    contents = CSV.open file, headers: true, header_converters: :symbol
    contents.each do |row|
      create_districts(row)
      if file == "./data/Kindergartners in full-day program.csv"
        collect_kg_participation_data(row)
      else
        collect_hs_graduation_data(row)
      end
    end
  end

  def create_districts(row)
    unless all_districts.any? {|district| district.name == row[:location].upcase}
      all_districts << District.new({name: row[:location].upcase})
    end
  end

  def create_enrollments
    all_districts.each do |district|
      unless hs_district_with_data.empty?
        all_enrollments << Enrollment.new({name: district.name.upcase,
          kindergarten_participation: kg_district_with_data.fetch(district.name.upcase),
          high_school_graduation: hs_district_with_data.fetch(district.name.upcase)})
      else
        all_enrollments << Enrollment.new({name: district.name.upcase,
          kindergarten_participation: kg_district_with_data.fetch(district.name.upcase)})
      end
    end
    all_enrollments
  end

  def collect_kg_participation_data(row)
    unless kg_district_with_data.has_key?(row[:location].upcase)
      kg_district_with_data[row[:location].upcase] = {row[:timeframe].to_i => format_percentage(row[:data].to_f)}
    else
      kg_district_with_data.fetch(row[:location].upcase).merge!({row[:timeframe].to_i => format_percentage(row[:data].to_f)})
    end
  end

  def collect_hs_graduation_data(row)
    unless hs_district_with_data.has_key?(row[:location].upcase)
      hs_district_with_data[row[:location].upcase] = {row[:timeframe].to_i => format_percentage(row[:data].to_f)}
    else
      hs_district_with_data.fetch(row[:location].upcase).merge!({row[:timeframe].to_i => format_percentage(row[:data].to_f)})
    end
  end

end
