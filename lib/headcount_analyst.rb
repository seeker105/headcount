require 'pry'
require 'csv'

class HeadcountAnalyst

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(dist_name, comparison_hash)
    submitted_district_avg = kindergarten_participation_avg_per_location(dist_name)
    comparison_avg = kindergarten_participation_avg_per_location(comparison_hash[:against])
    (submitted_district_avg / comparison_avg).round(3)
  end

  def kindergarten_participation_avg_per_location(dist_name)
    @district_repo.find_by_name(dist_name).enrollment.kindgarten_participation_avg_across_all_years
  end

  def kindergarten_participation_rate_variation_trend(dist_name, comparison_hash)

  end

end
