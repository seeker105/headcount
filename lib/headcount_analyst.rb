require 'pry'
require 'csv'
require_relative '../lib/clean_data'
require_relative '../lib/statewide_categories'

class HeadcountAnalyst
  include CleanData
  include StatewideCategories

  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(name, comparison)
    original = kd_participation_total_avg_for_location(name)
    compared = kd_participation_total_avg_for_location(comparison[:against])
    format_pct(original / compared)
  end

  def kd_participation_total_avg_for_location(name)
    format_pct(district_repo.kd_participation_avg_all_yrs(name))
  end

  def kd_participation_avg_for_each_year(name)
    district_repo.find_by_name(name).enrollment.kindergarten_participation
  end

  def kindergarten_participation_rate_variation_trend(name, comparison)
    original = kd_participation_avg_for_each_year(name)
    compared = kd_participation_avg_for_each_year(comparison[:against])
    years_and_variation_trends(original, compared)
  end

  def years_and_variation_trends(original, compared)
    original.each_key.with_object({}) do |key, result|
      result[key] = format_pct(original[key] / compared[key])
    end
  end

  def kindergarten_participation_rate_divided_by_state_avg(name)
    kg = district_repo.kd_participation_avg_all_yrs(name)
    state = district_repo.kd_participation_avg_all_yrs('COLORADO')
    format_pct(kg / state)
  end

  def high_school_grad_rate_divided_by_state_avg(name)
    hs = district_repo.graduation_avg_all_years(name)
    state = district_repo.graduation_avg_all_years('COLORADO')
    format_pct(hs / state)
  end

  def kindergarten_participation_against_high_school_graduation(name)
    kinder_var = kindergarten_participation_rate_divided_by_state_avg(name)
    grad_var   = high_school_grad_rate_divided_by_state_avg(name)
    (kinder_var / grad_var).round(3)
  end


  def compare_multiple_districts_to_state_avg(districts)
    districts.map do |district|
      district = district.name if district.class == District
      compare_single_district_to_state_avg(district)
    end
  end

  def compare_single_district_to_state_avg(name)
    var = kindergarten_participation_against_high_school_graduation(name)
    within_range?(var)
  end

  def within_range?(num)
    (0.6...1.5).member?(num)
  end

  def correlation_found?(array)
    array.count { |bool| bool } > (array.count * 0.70)
  end

  def check_correlation(districts)
    bools = compare_multiple_districts_to_state_avg(districts)
    correlation_found?(bools)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(input)
    if input.has_value?('STATEWIDE')
      check_correlation(district_repo.districts)
    else
      check_correlation(input.values.flatten)
    end
  end

  def top_statewide_test_year_over_year_growth(args)
    raise InsufficientInformationError,
      "A grade must be provided to answer this question" unless SUBJECTS.include?(args[:subject])
    raise UnknownDataError,
      "#{args[:grade]} is not a known grade" unless GRADE.include?(args[:grade])

    unless args.has_key?(:top)
      

    binding.pry
    # iteration 5 method
  end

end
