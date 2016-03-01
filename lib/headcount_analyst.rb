require 'pry'
require 'csv'

class HeadcountAnalyst

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(dist_name, comparison_hash)
    original   = kindergarten_participation_avg_per_location(dist_name)
    comparison = kindergarten_participation_avg_per_location(comparison_hash[:against])
    (original / comparison).round(3)
  end

  def kindergarten_participation_avg_per_location(dist_name)
    @district_repo.find_by_name(dist_name).enrollment.kindgarten_participation_avg_across_all_years
  end

  def kindergarten_participation_rate_variation_trend(dist_name, comparison_hash)
    result = {}
    original   = @district_repo.find_by_name(dist_name).enrollment.kindergarten_participation
    comparison = @district_repo.find_by_name(comparison_hash[:against]).enrollment.kindergarten_participation
    original.each_key do |key|
      result[key] = (original[key] / comparison[key]).round(3)
    end
    result
  end

end
