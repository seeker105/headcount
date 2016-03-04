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
    # binding.pry
    original = kd_participation_avg_for_each_year(name)
    compared = kd_participation_avg_for_each_year(comparison[:against])
    # binding.pry
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
    format_percentage(kindergarten_variation / graduation_variation)
  end

  def compare_district_to_state_avg(name)
    var = kindergarten_participation_against_high_school_graduation(name)
    (0.6..1.5).member?(var)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(for_hash)
    # if for_hash.has_value?('STATEWIDE')
    #   all_districts = district_repo.districts.map do |district|
    #     district.enrollment.graduation_avg_all_years
    #   end
    #   final = all_districts.select do |num|
    #     (0.6...1.5).member?(num)
    #   end
    #   # binding.pry
    #   if final.count > 127
    #     return true
    #   else
    #     return false
    #   end
    #
    # elsif for_hash.has_key?(:for)
    #   compare_district_to_state_avg(for_hash[:for])
    #
    # elsif for_hash.has_key?(:across)
    #   var = for_hash[:across].map do |district|
    #     district_repo.find_by_name(district).enrollment.graduation_avg_all_years
    #   end.reduce(:+) / for_hash[:across].count
    #   var > 0.7
    # end
    unless for_hash.has_key?(:across)
      name = for_hash[:for]
      # binding.pry
      puts "\n\n\n"
      # binding.pry
      puts kindergarten_participation_against_high_school_graduation("ACADEMY 20")
      # binding.pry
      # puts "Statewide ="
      # binding.pry
      binding.pry
      result = []
      district_repo.districts.each do |district|
        name = district.name
        calculated = kindergarten_participation_against_high_school_graduation(name)
        result << calculated
      end
    end

  end

end
