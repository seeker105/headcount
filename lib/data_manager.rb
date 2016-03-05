require 'pry'
require 'csv'
require_relative '../lib/district_repository'
require_relative '../lib/enrollment_repository'
require_relative '../lib/district'
require_relative '../lib/enrollment'
require_relative '../lib/clean_data'


class DataManager
  include CleanData

  attr_reader :all_districts, :all_enrollments, :all_stw_tests,
              :kg_district_with_data, :hs_district_with_data,
              :third_grade_data, :eighth_grade_data, :math, :reading, :writing

  def initialize
    @all_districts = []
    @all_enrollments = []
    @all_stw_tests = []

    @kg_district_with_data = {}
    @hs_district_with_data = {}
    @third_grade_data = {}
    @eighth_grade_data = {}
  end

  def load_data(data_hash)
    data_hash.each_value do |value|
      parse_loaded_data(value)
    end
  end

  def parse_loaded_data(data_hash)
    data_hash.each_pair do |name, file|
      parse_csv_data(name, file)
    end
  end

  def parse_csv_data(name, file)
    contents = CSV.open file, headers: true, header_converters: :symbol
    contents.each do |row|
      create_districts(row)
      if enrollments_map.include?(name)
        collect_enrollments_data(enrollments_map[name], row)
      elsif statewide_test_map.include?(name)
        collect_statewide_test_data(statewide_test_map[name], row)
      end
    end
  end

  def create_districts(row)
    unless all_districts.any? {|district| district.name == row[:location].upcase}
      all_districts << District.new({name: row[:location].upcase})
    end
  end

  def enrollments_map
    {:kindergarten => kg_district_with_data,
     :high_school_graduation => hs_district_with_data}
  end

  def collect_enrollments_data(group, row)
    unless group.has_key?(row[:location].upcase)
      group[row[:location].upcase] =
        {row[:timeframe].to_i => format_percentage(row[:data].to_f)}
    else
      group.fetch(row[:location].upcase).merge!({row[:timeframe].to_i =>
         format_percentage(row[:data].to_f)})
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

  def statewide_test_map
    { third_grade: third_grade_data, eighth_grade: eighth_grade_data}
      # math: math_data, reading: reading_data, writing: writing_data}
  end

  def collect_statewide_test_data(group, row)
    data_format = {row[:timeframe].to_i => {row[:score].downcase.to_sym => row[:data].to_f}}
    unless group.has_key?(row[:location].upcase)
      group[row[:location].upcase] = data_format

    else
      unless group.dig(row[:location].upcase, row[:timeframe].to_i).nil?
        group.dig(row[:location].upcase, row[:timeframe].to_i).merge!({row[:score].downcase.to_sym => row[:data].to_f})
      else
        group.fetch(row[:location].upcase).merge!(data_format)
      end
    end
  end

  def create_stw_tests
    all_districts.each do |district|
      unless eighth_grade_data.empty?
        all_stw_tests << StatewideTest.new({name: district.name.upcase,
          third_grade: third_grade_data.fetch(district.name.upcase),
          eighth_grade: eighth_grade_data.fetch(district.name.upcase)})
      else
        all_stw_tests << StatewideTest.new({name: district.name.upcase,
          third_grade: third_grade_data.fetch(district.name.upcase)})
      end
    end
    all_stw_tests
  end

end
