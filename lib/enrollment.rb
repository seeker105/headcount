require 'pry'

class Enrollment
  attr_reader :enrollment_data

  def initialize(enrollment_data)
    @enrollment_data = enrollment_data
  end

  def kindergarten_participation_by_year
    enrollment_data[:kindergarten_participation]
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
