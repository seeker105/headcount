require 'pry'
require_relative '../lib/economic_profile'
require_relative '../lib/data_manager'

class EconomicProfileRepository
  attr_reader :economic_profiles

  def initialize(economic_profiles = [])
    @economic_profiles = economic_profiles
  end

  def load_data(data)
    data_manager = DataManager.new
    data_manager.load_data(data)
    @economic_profiles = data_manager.create_economic_profiles
  end

  def find_by_name(name)
    @economic_profiles.find { |economic_profile| economic_profile.name == name.upcase }
  end

end
