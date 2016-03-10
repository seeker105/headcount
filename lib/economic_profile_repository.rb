require 'pry'
require_relative '../lib/data_manager'

class EconomicProfileRepository
  attr_accessor :economic_profiles

  def initialize(data = {})
    @economic_profiles = load_data(data)
  end

  def load_data(data)
    data_manager = DataManager.new
    data_manager.load_data(data)
    populate_repo(data_manager.create_economic_profiles)
  end

  def populate_repo(raw_profiles)
    @economic_profiles = raw_profiles.each_with_object({}) do |profile, object|
      object[profile.name] = profile
    end
  end

  def find_by_name(name)
    @economic_profiles[name.upcase]
  end

end
