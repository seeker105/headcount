require 'pry'
require_relative 'float'

class Enrollment
  attr_accessor :enrollment_data

  def initialize(enrollment_data)
    @enrollment_data = enrollment_data
    @enrollment_data = clean_data
  end

  def name
    enrollment_data[:name]
  end

  def clean_data
    # binding.pry
    enrollment_data.each_key do |category|
      # binding.pry
      unless category == :name
        enrollment_data[category].each_pair do |year, percentage|
          enrollment_data[category][year] = percentage.decimal_floor_3
        end
      end
    end
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

  def kd_participation_avg_all_yrs
    years = kindergarten_participation_by_year.values
    years.reduce(:+) / years.count
  end


end

if __FILE__ == $0
  e = Enrollment.new({:name => "ACADEMY 20",
            :kindergarten_participation => { 2010 => 0.3915,
                                             2011 => 0.35356,
                                             2012 => 0.2677 }})
end
