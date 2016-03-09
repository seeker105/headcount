require 'pry'
require 'csv'
require_relative '../lib/clean_data'
require_relative '../lib/district'
require_relative '../lib/enrollment'
require_relative '../lib/statewide_test'

class DataManager
  include CleanData

  attr_reader :all_districts, :all_enrollments,
                :all_stw_tests, :all_economic_profiles,
              :kg_dist_with_data, :hs_district_with_data,
              :third_grade_data, :eighth_grade_data,
              :math_data, :reading_data, :writing_data,
              :med_house_income_data, :child_in_pov_data,
                :free_or_reduce_lunch_data, :title_i_data

  def initialize
    @all_districts = []
    @all_enrollments = []
    @all_stw_tests = []
    @all_economic_profiles = []

    @kg_dist_with_data = {}
    @hs_district_with_data = {}

    @third_grade_data = {}
    @eighth_grade_data = {}

    @math_data = {}
    @reading_data = {}
    @writing_data = {}

    @med_house_income_data = {}
    @child_in_pov_data = {}
    @free_or_reduce_lunch_data = {}
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

  def district_alread_created?(row)
    all_districts.any? {|district| district.name == row[:location].upcase}
  end

  def create_districts(row)
    unless district_alread_created?(row)
      all_districts << District.new({name: row[:location].upcase})
    end
  end

  def create_repos(file, name, row)
    parse_enrollment_data(name, row)
    parse_statewide_test_data(name, row)
    parse_statewide_race_data(name, row)
    parse_economic_profile_data(file, name, row)
  end

  def parse_enrollment_data(name, row)
    if enrollments_map.include?(name)
      collect_enrollments_data(enrollments_map[name], row)
    end
  end

  def parse_statewide_test_data(name, row)
    if statewide_test_map.include?(name)
      collect_statewide_grade_data(statewide_test_map[name], row)
    end
  end

  def parse_statewide_race_data(name, row)
    if statewide_race_map.include?(name)
      collect_statewide_race_data(statewide_race_map[name], row)
    end
  end

  def parse_economic_profile_data(file, name, row)
    if economic_profile_map.include?(name)
      collect_economic_profile_data(file, economic_profile_map[name], row)
    end
  end

  def enrollments_map
    {:kindergarten => kg_dist_with_data,
     :high_school_graduation => hs_district_with_data}
  end

  def statewide_test_map
    { third_grade: third_grade_data, eighth_grade: eighth_grade_data}
  end

  def statewide_race_map
    {math: math_data, reading: reading_data, writing: writing_data}
  end

  def economic_profile_map
    {median_household_income: med_house_income_data,
     children_in_poverty: child_in_pov_data,
     free_or_reduced_price_lunch: free_or_reduce_lunch_data,
     title_i: title_i_data}
  end

  def collect_enrollments_data(group, row)
    standard_location_year_percentage_data(group, row)
  end

  def create_enrollments
    all_enrollments = all_districts.map do |district|
      create_indiv_enrollments(district)
    end
  end

  def create_indiv_enrollments(district)
    unless hs_district_with_data.empty?
      Enrollment.new({name: district.name.upcase,
kindergarten_participation: kg_dist_with_data.fetch(district.name.upcase),
high_school_graduation: hs_district_with_data.fetch(district.name.upcase)})
    else
      Enrollment.new({name: district.name.upcase,
kindergarten_participation: kg_dist_with_data.fetch(district.name.upcase)})
    end
  end

  def format_nested_hash(main_key, sub_key, sub_value)
    { main_key => { sub_key => sub_value }}
  end

  def collect_statewide_grade_data(group, row)
    district = row[:location].upcase
    year     = row[:timeframe].to_i
    score    = row[:score].downcase.to_sym
    data     = format_pct(row[:data].to_f)
    create_or_merge_stw_grade_data(group, row, district, year, score, data)
  end

  def create_or_merge_stw_grade_data(group, row, district, year, score, data)
    unless group.has_key?(district)
      group[district] = format_nested_hash(year, score, data)
    else
      unless group.dig(district, year).nil?
        group.dig(district, year).merge!({score => format_pct(row[:data].to_f)})
      else
        group.fetch(district).merge!(format_nested_hash(year, score, data))
      end
    end
  end

  def collect_statewide_race_data(group, row)
    data_format = {format_string_to_key(row[:race_ethnicity]) =>
       {row[:timeframe].to_i => format_pct(row[:data].to_f)}}
    unless group.has_key?(row[:location].upcase)
      group[row[:location].upcase] = data_format
    else
      unless group.dig(row[:location].upcase,
          format_string_to_key(row[:race_ethnicity])).nil?
        group.dig(row[:location].upcase,
          format_string_to_key(row[:race_ethnicity])).merge!(
          {row[:timeframe].to_i => format_pct(row[:data].to_f)})
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
      create_inividual_statewide_test(district)
    end
  end

  def create_inividual_statewide_test(district)
    StatewideTest.new({name: district.name.upcase,
      third_grade: third_grade_data.fetch(district.name.upcase),
      eighth_grade: eighth_grade_data.fetch(district.name.upcase),
      math: math_data.fetch(district.name.upcase),
      reading: reading_data.fetch(district.name.upcase),
      writing: writing_data.fetch(district.name.upcase)
    })
  end

  def collect_economic_profile_data(file, group, row)
    if file.include?('Median')
      collect_med_house_income_data(group, row)
    elsif file.include?('lunch')
      collect_reduced_price_lunch_data(group, row)
    else
      standard_location_year_percentage_data(group, row)
    end
  end

  def collect_med_house_income_data(group, row)
    range = row[:timeframe].split('-').map(&:to_i)
    unless group.has_key?(row[:location].upcase)
      group[row[:location].upcase] =
        {range => format_fixnum(row[:data].to_i)}
    else
      group.fetch(row[:location].upcase).merge!({range =>
        format_fixnum(row[:data].to_i)})
    end
  end

  def collect_reduced_price_lunch_data(group, row)
    if row[:poverty_level] == "Eligible for Free or Reduced Lunch"
      if row[:dataformat] == "Percent"
        unless group.has_key?(row[:location].upcase)
          group[row[:location].upcase] =
            {row[:timeframe].to_i => {percentage: format_pct(row[:data].to_f),
                                      total: 0}}
        else
          group.fetch(row[:location].upcase).merge!({row[:timeframe].to_i =>
            {percentage: format_pct(row[:data].to_f),
              total: group.dig(row[:location].upcase,
                row[:timeframe].to_i, :total)}})
        end
      else
        unless group.has_key?(row[:location].upcase)
          group[row[:location].upcase] =
            {row[:timeframe].to_i => {percentage: 0,
                                      total: format_fixnum(row[:data].to_i)}}
        else
          group.fetch(row[:location].upcase).merge!({row[:timeframe].to_i =>
            {percentage: group.dig(row[:location].upcase,
              row[:timeframe].to_i, :percentage),
                total: format_fixnum(row[:data].to_i)}})
        end
      end
    end
  end

  def create_economic_profiles
    all_economic_profiles = all_districts.map do |district|
      name = district.name.upcase
      profile = create_indiv_economic_profile(name)
      profile.name = name
      profile
    end
  end

  def create_indiv_economic_profile(name)
    EconomicProfile.new(
      {median_household_income: med_house_income_data.fetch(name),
       children_in_poverty: child_in_pov_data.fetch(colorado_check(name)),
       free_or_reduced_price_lunch: free_or_reduce_lunch_data.fetch(name),
       title_i: title_i_data.fetch(name)
      })
  end

  def colorado_check(name)
    name.upcase == "COLORADO" ? "ACADEMY 20" : name.upcase
  end

  def standard_location_year_percentage_data(group, row)
    unless group.has_key?(row[:location].upcase)
      group[row[:location].upcase] =
        {row[:timeframe].to_i => format_pct(row[:data].to_f)}
    else
      group.fetch(row[:location].upcase).merge!({row[:timeframe].to_i =>
         format_pct(row[:data].to_f)})
    end
  end

end
