require 'pry'

class Enrollment
  attr_reader :name, :kindergarten_participation, :high_school_graduation

  def initialize(data)
    @name = data[:name].upcase
    @kindergarten_participation = clean_data(data[:kindergarten_participation])
    @high_school_graduation = clean_data(data[:high_school_graduation])
  end

  def clean_data(data)
    return data if data.nil?
    data.each_pair { |year, pct| data[year] = format_percentage(pct) }
  end

  def format_percentage(pct)
    case pct
    when Float then (pct * 1000).floor / 1000.0
    when Fixnum then pct.to_f
    else "bad percentage data"
    end
  end

  def kindergarten_participation_by_year
    kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation.fetch(year) if contains_year?(year)
  end

  def contains_year?(year)
    raise ArgumentError unless year.is_a? Fixnum
    kindergarten_participation.has_key?(year)
  end

  def kd_participation_avg_all_yrs
    years = kindergarten_participation.values
    years.reduce(:+) / years.count
  end

  def graduation_rate_by_year
    high_school_graduation
  end

end
