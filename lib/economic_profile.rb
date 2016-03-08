require 'pry'
require_relative '../lib/custom_errors'

class EconomicProfile
  attr_accessor :name
  attr_reader   :median_household_income, :children_in_poverty,
                :free_or_reduced_price_lunch, :title_i

  def initialize(data)
    @median_household_income     = data[:median_household_income]
    @children_in_poverty         = data[:children_in_poverty]
    @free_or_reduced_price_lunch = data[:free_or_reduced_price_lunch]
    @title_i                     = data[:title_i]
  end

  def median_household_income_in_year(year)
    raise UnknownDataError unless year_valid?(year, median_household_income)
    total = collect_household_income_data_per_year(year)
    calc_average(total)
  end

  def year_valid?(year, collection)
    collection.keys.flatten.include?(year)
  end

  def collect_household_income_data_per_year(year)
    median_household_income.each_pair.with_object([]) do |(k, v), obj|
      obj << v if (k.first..k.last).member?(year)
    end
  end

  def calc_average(collection)
    collection.reduce(:+) / collection.length
  end

  def median_household_income_average
    calc_average(median_household_income.values)
  end

  def children_in_poverty_in_year(year)
    raise UnknownDataError unless year_valid?(year, children_in_poverty)
    children_in_poverty.fetch(year)
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    raise UnknownDataError unless year_valid?(year, free_or_reduced_price_lunch)
    free_or_reduced_price_lunch.fetch(year)[:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    raise UnknownDataError unless year_valid?(year, free_or_reduced_price_lunch)
    free_or_reduced_price_lunch.fetch(year)[:total]
  end

  def title_i_in_year(year)
    raise UnknownDataError unless year_valid?(year, title_i)
    title_i.fetch(year)
  end

end
