require 'pry'

class Enrollment
  attr_reader :enrollment_data

  def initialize(enrollment_data)
    @enrollment_data = enrollment_data
  end

  def kindergarten_participation_by_year
    enrollment_data[:kindergarten_participation]
  end

  def clean_participation_data
    enrollment_data[:kindergarten_participation].values.map do |percentage|
      if percentage.class == Float
        percentage.to_s[0..4].to_f
      elsif percentage == 1
        percentage = 1.00
      elsif percentage == 0
        percentage = 0.00
      else
        percentage = "bad data"
      end
    end
  end

  def kindergarten_participation_in_year(year)
    if contains_year?(year)
      enrollment_data[:kindergarten_participation].fetch(year)
    else
      nil
    end
  end

  def contains_year?(year)
    raise ArgumentError unless year.class == Fixnum
    enrollment_data[:kindergarten_participation].has_key?(year)
  end


end
