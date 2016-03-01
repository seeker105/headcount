require 'pry'

class Enrollment
  attr_reader :name, :kindergarten_participation

  def initialize(data)
    @name = data[:name]
    @kindergarten_participation = clean_data(data[:kindergarten_participation])
  end

  def clean_data(data)
    data.each_pair { |year, pct| data[year] = format_percentage(pct) }
  end

  def format_percentage(pct)
    if pct.is_a? Float
      # pct.round(3)
      pct = pct.to_s[0..4].to_f
    elsif pct.is_a? Fixnum
      pct = pct.to_f
    else
      pct = "bad data"
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
