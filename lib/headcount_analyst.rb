require 'pry'
require 'csv'
require_relative '../lib/clean_data'

class HeadcountAnalyst
  include CleanData
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(name, comparison)
    original = kd_participation_total_avg_for_location(name)
    compared = kd_participation_total_avg_for_location(comparison[:against])
    format_percentage(original / compared)
  end

  def kd_participation_total_avg_for_location(name)
    format_percentage(district_repo.find_by_name(name).enrollment.kd_participation_avg_all_yrs)
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
    result = Hash.new
    original.each_key do |key|
      result[key] = format_percentage(original[key] / compared[key])
    end
    result
  end

  def kindergarten_participation_rate_divided_by_state_avg(name)
    kg = district_repo.find_by_name(name).enrollment.kd_participation_avg_all_yrs
    state = district_repo.find_by_name('COLORADO').enrollment.kd_participation_avg_all_yrs
    format_percentage(kg / state)
  end

  def high_school_grad_rate_divided_by_state_avg(name)
    hs = district_repo.find_by_name(name).enrollment.graduation_avg_all_years
    state = district_repo.find_by_name('COLORADO').enrollment.graduation_avg_all_years
    format_percentage(hs / state)
  end

  def kindergarten_participation_against_high_school_graduation(name)
    kindergarten_variation = kindergarten_participation_rate_divided_by_state_avg(name)
    graduation_variation   = high_school_grad_rate_divided_by_state_avg(name)
    (kindergarten_variation / graduation_variation).round(3)
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
    if input.has_key?(:for)
      if input[:for] == 'STATEWIDE'
        check_correlation(district_repo.districts)
      else
        compare_single_district_to_state_avg(input[:for])
      end
    else
      check_correlation(input[:across])
    end
  end

end
