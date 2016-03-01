require 'pry'

class Enrollment
  attr_reader :kindergarten_participation
  attr_accessor :name

  def initialize(data)
    @name = data[:name].upcase
    @kindergarten_participation = clean_data(data[:kindergarten_participation])
  end

  def clean_data(data)
    data.each_pair { |year, pct| data[year] = format_percentage(pct) }
  end

  def format_percentage(pct)
    case pct
    # when Float then pct.to_s[0..4].to_f
    when Float then (pct * 1000).floor / 1000.0
    when Fixnum then pct.to_f
    else "bad data"
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

end
