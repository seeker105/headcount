require 'pry'
require 'csv'
require_relative '../lib/district_repository'
require_relative '../lib/enrollment_repository'
require_relative '../lib/district'
require_relative '../lib/enrollment'
require_relative '../lib/clean_data'


class DataManager
  include CleanData

  attr_reader :all_districts, :all_enrollments, :all_stw_tests, :all_economic_profiles,
              :kg_district_with_data, :hs_district_with_data,
              :third_grade_data, :eighth_grade_data,
              :math_data, :reading_data, :writing_data,
              :median_household_income_data, :children_in_poverty_data,
                :free_or_reduced_price_lunch_data, :title_i_data

  def initialize
    @all_districts = []
    @all_enrollments = []
    @all_stw_tests = []
    @all_economic_profiles = []

    @kg_district_with_data = {}
    @hs_district_with_data = {}

    @third_grade_data = {}
    @eighth_grade_data = {}

    @math_data = {}
    @reading_data = {}
    @writing_data = {}

    @median_household_income_data = {}
    @children_in_poverty_data = {}
    @free_or_reduced_price_lunch_data = {}
    @title_i_data = {}
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
      create_repos(file, name, row)
    end
  end

  def create_districts(row)
    unless all_districts.any? {|district| district.name == row[:location].upcase}
      all_districts << District.new({name: row[:location].upcase})
    end
  end

  def create_repos(file, name, row)
    if enrollments_map.include?(name)
      # remove file when done
      collect_enrollments_data(file, enrollments_map[name], row)
    elsif statewide_test_map.include?(name)
      collect_statewide_grade_data(statewide_test_map[name], row)
    elsif statewide_race_map.include?(name)
      collect_statewide_race_data(file, statewide_race_map[name], row)
    elsif economic_profile_map.include?(name)
      collect_economic_profile_data(file, economic_profile_map[name], row)
    end
  end

  def enrollments_map
    {:kindergarten => kg_district_with_data,
     :high_school_graduation => hs_district_with_data}
  end

  def collect_enrollments_data(file, group, row)
    standard_location_year_percentage_data(file, group, row)
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
  end

  def collect_statewide_grade_data(group, row)
    data_format = {row[:timeframe].to_i => {row[:score].downcase.to_sym => format_percentage(row[:data].to_f)}}
    unless group.has_key?(row[:location].upcase)
      group[row[:location].upcase] = data_format
    else
      unless group.dig(row[:location].upcase, row[:timeframe].to_i).nil?
        group.dig(row[:location].upcase, row[:timeframe].to_i).merge!({row[:score].downcase.to_sym => format_percentage(row[:data].to_f)})
      else
        group.fetch(row[:location].upcase).merge!(data_format)
      end
    end
  end

  def statewide_race_map
    {math: math_data, reading: reading_data, writing: writing_data}
  end

  def collect_statewide_race_data(file, group, row)
    data_format = {format_string_to_key(row[:race_ethnicity]) => {row[:timeframe].to_i => format_percentage(row[:data].to_f)}}
    unless group.has_key?(row[:location].upcase)
      group[row[:location].upcase] = data_format
    else
      unless group.dig(row[:location].upcase, format_string_to_key(row[:race_ethnicity])).nil?
        group.dig(row[:location].upcase, format_string_to_key(row[:race_ethnicity])).merge!({row[:timeframe].to_i => format_percentage(row[:data].to_f)})
      else
        group.fetch(row[:location].upcase).merge!(data_format)
      end
    end
  end

  def format_string_to_key(string)
    string.gsub("Hawaiian/", "").gsub(" ", "_").downcase.to_sym
  end

  def create_statewide_tests
    # remove all_stw_tests variable?
    all_stw_tests = all_districts.map do |district|
      StatewideTest.new({name: district.name.upcase,
        third_grade: third_grade_data.fetch(district.name.upcase),
        eighth_grade: eighth_grade_data.fetch(district.name.upcase),
        math: math_data.fetch(district.name.upcase),
        reading: reading_data.fetch(district.name.upcase),
        writing: writing_data.fetch(district.name.upcase)
      })
    end
  end

  def economic_profile_map
    {median_household_income: median_household_income_data,
     children_in_poverty: children_in_poverty_data,
     free_or_reduced_price_lunch: free_or_reduced_price_lunch_data,
     title_i: title_i_data}
  end

  def collect_economic_profile_data(file, group, row)
    if file.include?('Median')
      collect_median_household_income_data(group, row)
    elsif file.include?('lunch')
      collect_reduced_price_lunch_data(group, row)
    else
      standard_location_year_percentage_data(file, group, row)
    end
  end

  def collect_median_household_income_data(group, row)
    range = row[:timeframe].split('-').map(&:to_i)
    unless group.has_key?(row[:location].upcase)
      group[row[:location].upcase] =
        {range => format_fixnum(row[:data].to_i)}
    else
      group.fetch(row[:location].upcase).merge!({range => format_fixnum(row[:data].to_i)})
    end
  end

  def collect_reduced_price_lunch_data(group, row)
    if row[:poverty_level] == "Eligible for Free or Reduced Lunch"
      if row[:dataformat] == "Percent"
        unless group.has_key?(row[:location].upcase)
          group[row[:location].upcase] =
            {row[:timeframe].to_i => {percentage: format_percentage(row[:data].to_f),
                                      total: 0}}
        else
          group.fetch(row[:location].upcase).merge!({row[:timeframe].to_i =>
            {percentage: format_percentage(row[:data].to_f),
             total: group.dig(row[:location].upcase, row[:timeframe].to_i, :total)}})
        end
      else
        unless group.has_key?(row[:location].upcase)
          group[row[:location].upcase] =
            {row[:timeframe].to_i => {percentage: 0,
                                      total: format_fixnum(row[:data].to_i)}}
        else
          group.fetch(row[:location].upcase).merge!({row[:timeframe].to_i =>
            {percentage: group.dig(row[:location].upcase, row[:timeframe].to_i, :percentage),
             total: format_fixnum(row[:data].to_i)}})
        end
      end
    end
  end

  def create_economic_profiles
    # remove all_stw_tests variable?
    all_economic_profiles = all_districts.map do |district|
      EconomicProfile.new({name: district.name.upcase,
        median_household_income: median_household_income_data.fetch(district.name.upcase),
        children_in_poverty: children_in_poverty_data.fetch(district.name.upcase),
        free_or_reduced_price_lunch: free_or_reduced_price_lunch_data.fetch(district.name.upcase),
        title_i: title_i_data.fetch(district.name.upcase)
        })
      end
    end


  def standard_location_year_percentage_data(file, group, row)
    unless group.has_key?(row[:location].upcase)
      group[row[:location].upcase] =
        {row[:timeframe].to_i => format_percentage(row[:data].to_f)}
    else
      group.fetch(row[:location].upcase).merge!({row[:timeframe].to_i =>
         format_percentage(row[:data].to_f)})
    end
  end

end
