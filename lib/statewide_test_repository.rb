require 'pry'
require_relative '../lib/statewide_test'
require_relative '../lib/data_manager'

class StatewideTestRepository
  attr_reader :stw_tests

  def initialize(stw_tests = [])
    @stw_tests = stw_tests
  end

  def load_data(data)
    data_manager = DataManager.new
    data_manager.load_data(data)
    @stw_tests = data_manager.create_stw_tests
  end

end
