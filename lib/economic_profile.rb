require 'pry'
require_relative '../lib/custom_errors'


class EconomicProfile
  attr_accessor :name

  def initialize(data)
    # @name                        = data[:name].upcase
    @median_household_income     = data[:median_household_income]
    @children_in_poverty         = data[:children_in_poverty]
    @free_or_reduced_price_lunch = data[:free_or_reduced_price_lunch]
    @title_i                     = data[:title_i]
  end

  def median_household_income_in_year(year)
    raise UnknownDataError unless year.is_a? Fixnum
    total = @median_household_income.each_pair.with_object([]) do |(k, v), obj|
      obj << v if (k.first..k.last).member?(year)
    end
    calc_average(total)
  end

  def calc_average(collection)
    collection.reduce(:+) / collection.length
  end

  def median_household_income_average
    calc_average(@median_household_income.values)
  end

  def children_in_poverty_in_year(year)
    raise UnknownDataError unless @children_in_poverty.has_key?(year)
    @children_in_poverty.fetch(year)
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    raise UnknownDataError unless @free_or_reduced_price_lunch.has_key?(year)
    @free_or_reduced_price_lunch.fetch(year)[:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    raise UnknownDataError unless @free_or_reduced_price_lunch.has_key?(year)
    @free_or_reduced_price_lunch.fetch(year)[:total]
  end


end
