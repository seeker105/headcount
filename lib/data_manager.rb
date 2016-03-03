require 'pry'
require 'csv'
require_relative '../lib/district_repository'
require_relative '../lib/enrollment_repository'
require_relative '../lib/district'
require_relative '../lib/enrollment'

require_relative '../lib/clean_data'


class DataManager
  include CleanData

  attr_reader :all_districts, :kg_district_with_data, :hs_district_with_data

  def initialize(data_hash)
    @all_districts = []
    @kg_district_with_data = {}
    @hs_district_with_data = {}
    load_data(data_hash)
  end

  def load_data(data_hash)
    data_hash.each_value do |value|
      # enrollment route vs statewide route
      parse_loaded_data(value)
    end
  end

  def parse_loaded_data(data_hash)
    data_hash.each_value do |value|
      parse_csv_data(value)
    end
  end

  # def parse_loaded_data(data_hash)
  #   data_hash.each_pair do |key, value|
  #     parse_csv_data(value)
  #   end
  # end

  def parse_csv_data(file)
    contents = CSV.open file, headers: true, header_converters: :symbol
    contents.each do |row|
      district_names(row)
      if file == "./data/Kindergartners in full-day program.csv"
        collect_kg_participation_data(row)
      else
        collect_hs_graduation_data(row)
      end
    end
  end

  def district_names(row)
    unless all_districts.include?(row[:location])
      all_districts << row[:location]
    end
  end

  def collect_kg_participation_data(row)
    unless kg_district_with_data.has_key?(row[:location])
      kg_district_with_data[row[:location]] = {row[:timeframe].to_i => format_percentage(row[:data].to_f)}
    else
      kg_district_with_data.fetch(row[:location]).merge!({row[:timeframe].to_i => format_percentage(row[:data].to_f)})
    end
  end

  def collect_hs_graduation_data(row)
    unless hs_district_with_data.has_key?(row[:location])
      hs_district_with_data[row[:location]] = {row[:timeframe].to_i => format_percentage(row[:data].to_f)}
    else
      hs_district_with_data.fetch(row[:location]).merge!({row[:timeframe].to_i => format_percentage(row[:data].to_f)})
    end
  end


  # def district_names(file_name)
  #   rows = CSV.open filename, headers: true, header_converters: :symbol
  #   result = []
  #   rows.each do [row]
  #     if !result.include? row[:location]
  #       result << row[:location]
  #     end
  #     result
  #   # creates array of all uniq district names
  #   # then passes that back to the District Repo class
  #   # who then creates all the individual District Objects
  # end

  def year_value_pairs(district_name)
    # for the given district return an array of year => percentage
    # hashes for that district
    # => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}
  end


end
