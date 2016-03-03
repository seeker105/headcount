require 'pry'
require 'csv'

class HeadcountAnalyst

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(name, comparison)
    original = kd_participation_total_avg_for_location(name)
    compared = kd_participation_total_avg_for_location(comparison[:against])
    (original / compared).round(3)
  end

  def kd_participation_total_avg_for_location(name)
    @district_repo.find_by_name(name).enrollment.kd_participation_avg_all_yrs
  end

  def kd_participation_avg_for_each_year(name)
    @district_repo.find_by_name(name).enrollment.kindergarten_participation
  end

  def kindergarten_participation_rate_variation_trend(name, comparison)
    original = kd_participation_avg_for_each_year(name)
    compared = kd_participation_avg_for_each_year(comparison[:against])
    years_and_variation_trends(original, compared)
  end

  def years_and_variation_trends(original, compared)
    result = Hash.new
    original.each_key do |key|
      result[key] = (original[key] / compared[key]).round(3)
    end
    result
  end

  def kindergarten_participation_against_high_school_graduation(name)
    kindergarten_variation = kindergarten_participation_rate_divided_by_state_avg(name)
    graduation_variation   = high_school_grad_rate_divided_by_state_avg(name)
    kindergarten_variation / graduation_variation
  end

  def kindergarten_participation_rate_divided_by_state_avg(name)
    kg = @district_repo.find_by_name(name).enrollment.kd_participation_avg_all_yrs
    state = @district_repo.find_by_name('COLORADO').enrollment.kd_participation_avg_all_yrs
    kg / state
  end

  def high_school_grad_rate_divided_by_state_avg(name)
    hs = @district_repo.find_by_name(name).enrollment.graduation_avg_all_years
    state = @district_repo.find_by_name('COLORADO').enrollment.graduation_avg_all_years
    hs / state
  end

end
