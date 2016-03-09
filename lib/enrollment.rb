require 'pry'
<<<<<<< HEAD
require_relative '../lib/clean_data'

class Enrollment
  include CleanData

  attr_reader :name, :kindergarten_participation, :high_school_graduation

  def initialize(data)
    @name = data[:name].upcase
    @kindergarten_participation = clean_data(data[:kindergarten_participation])
    @high_school_graduation = clean_data(data[:high_school_graduation])
=======
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
>>>>>>> master
  end

  def kindergarten_participation_by_year
    kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    if contains_year?(year, kindergarten_participation)
      kindergarten_participation.fetch(year)
    end
  end

  def contains_year?(year, group)
    raise ArgumentError unless year.is_a? Fixnum
    group.has_key?(year)
  end

  def kd_participation_avg_all_yrs
    compute_avg(kindergarten_participation.values)
  end

<<<<<<< HEAD
  def graduation_rate_by_year
    high_school_graduation
  end

  def graduation_avg_all_years
    compute_avg(high_school_graduation.values)
  end

  def compute_avg(array)
    array.reduce(:+) / array.count
  end

  def graduation_rate_in_year(year)
    if contains_year?(year, high_school_graduation)
      high_school_graduation.fetch(year)
    end
  end
=======
  def kd_participation_avg_all_yrs
    years = kindergarten_participation_by_year.values
    years.reduce(:+) / years.count
  end

  def graduation_rate_by_year
    enrollment_data[:high_school_graduation]
  end

  def graduation_rate_in_year(year)
    enrollment_data[:high_school_graduation][year]
  end

end
>>>>>>> master

if __FILE__ == $0
  e = Enrollment.new({:name => "ACADEMY 20",
            :kindergarten_participation => { 2010 => 0.3915,
                                             2011 => 0.35356,
                                             2012 => 0.2677 }})
end
