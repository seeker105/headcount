require 'pry'
require 'csv'
<<<<<<< HEAD

class HeadcountAnalyst
=======
require_relative '../lib/clean_data'

class HeadcountAnalyst
  include CleanData
  attr_reader :district_repo
>>>>>>> 4fd5972c4bc1bc6602a87731bf28bf760df355c3

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(name, comparison)
    original = kd_participation_total_avg_for_location(name)
    compared = kd_participation_total_avg_for_location(comparison[:against])
<<<<<<< HEAD
    (original / compared).decimal_floor_3
  end

  def kd_participation_total_avg_for_location(name)
    @district_repo.enrollment_by_name(name).kd_participation_avg_all_yrs
  end

  def kindergarten_participation_rate_variation_trend(name, comparison)
    original_hash = @district_repo.enrollment_by_name(name).kindergarten_participation_by_year
    comparison_hash = @district_repo.enrollment_by_name(comparison[:against]).kindergarten_participation_by_year
    result = {}
    original_hash.each_pair do |year, percentage|
      result[year] = (original_hash[year] / comparison_hash[year]).decimal_floor_3
=======
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
>>>>>>> 4fd5972c4bc1bc6602a87731bf28bf760df355c3
    end
    result
  end

<<<<<<< HEAD
  # def kd_participation_avg_for_each_year(name)
  #   @district_repo.enrollment_by_name(name).kindergarten_participation_by_year
  # end

  # def kindergarten_participation_rate_variation_trend(name, comparison)
  #   original = kd_participation_avg_for_each_year(name)
  #   compared = kd_participation_avg_for_each_year(comparison[:against])
  #   years_and_variation_trends(original, compared)
  # end

  # def years_and_variation_trends(original, compared)
  #   result = Hash.new
  #   original.each_key do |key|
  #     result[key] = (original[key] / compared[key]).round(3)
  #   end
  #   result
  # end
=======
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

  def compare_district_to_state_avg(name)
    var = kindergarten_participation_against_high_school_graduation(name)
    (0.6..1.5).member?(var)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(for_hash)
    if for_hash.has_value?('STATEWIDE')

      t_f_all = district_repo.districts.map do |district|
        compare_district_to_state_avg(district.name)
      end

      # final = t_f_all.select do |bool|
      #   bool == true
      # end.count
      # final > 127

      t_f_all.count { |bool| bool == true } > (t_f_all.count * 0.70)

    elsif for_hash.has_key?(:for)
      compare_district_to_state_avg(for_hash[:for])

    elsif for_hash.has_key?(:across)
      var = for_hash[:across].map do |district|
        district_repo.find_by_name(district).enrollment.graduation_avg_all_years
      end.reduce(:+) / for_hash[:across].count
      var > 0.7
    end

  end
>>>>>>> 4fd5972c4bc1bc6602a87731bf28bf760df355c3

end
