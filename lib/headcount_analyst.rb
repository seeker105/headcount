require 'pry'
require 'csv'

class HeadcountAnalyst

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(name, comparison)
    original = kd_participation_total_avg_for_location(name)
    compared = kd_participation_total_avg_for_location(comparison[:against])
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
    end
    result
  end

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

end
