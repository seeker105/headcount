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
    raise InsufficientInformationError unless args.has_key?(:grade)
    raise UnknownDataError unless GRADE.include?(args[:grade])

    growth_for_all_tests = parser(args).compact

    sorted = growth_for_all_tests.max_by { |data| data.last}

    if args.has_key?(:top)
      growth_for_all_tests.sort_by { |pair| pair.last }.reverse[0..args[:top]]

    elsif args.has_key?(:weighting)
      sorted

    else
      sorted
    end
  end

  def select_grade(args, stw_test)
    case args[:grade]
    when 3 then stw_test.third_grade
    when 8 then stw_test.eighth_grade
    end
  end

  def parser(args)
    district_repo.statewide_test_repo.statewide_tests.map do |stw_test|
      next if stw_test.name == "COLORADO"
      grade = select_grade(args, stw_test).clone

      if args.has_key?(:subject)
        calc_yr_to_yr_growth(stw_test.name, grade, args[:subject])
      else

        math    = calc_yr_to_yr_growth(stw_test.name, grade, :math)
        reading = calc_yr_to_yr_growth(stw_test.name, grade, :reading)
        writing = calc_yr_to_yr_growth(stw_test.name, grade, :writing)

        if args.has_key?(:weighting)
          # confirm weighing adds up to 1.0
          math    = [math.first, (args[:weighting][:math] * math.last)]
          reading = [reading.first, (args[:weighting][:reading] * reading.last)]
          writing = [writing.first, (args[:weighting][:writing] * writing.last)]

          total = (math.last + writing.last + reading.last)
          [stw_test.name, total]
        else
          total = ((math.last + writing.last + reading.last) / 3)
          [stw_test.name, total]
        end

      end
    end
  end

  def calc_yr_to_yr_growth(name, grade, subject)
    grade.delete_if { |key, value| value.dig(subject) == 0.0 }
    unless grade.length < 2
      growth = grade.dig(grade.keys.max, subject) -
                 grade.dig(grade.keys.min, subject)
      year   = (grade.keys.max - grade.keys.min)
      total  = growth.round(3) / year
      [name, total]
    else
      [name, 0.0]
    end
  end

end
