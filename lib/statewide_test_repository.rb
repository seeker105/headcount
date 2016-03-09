require 'pry'
# require_relative '../lib/statewide_test'
require_relative '../lib/data_manager'

class StatewideTestRepository
  attr_reader :statewide_tests

  def initialize(statewide_tests = [])
    @statewide_tests = statewide_tests
  end

  def load_data(data)
    data_manager = DataManager.new
    data_manager.load_data(data)
    @statewide_tests = data_manager.create_statewide_tests
  end

  def find_by_name(name)
    @statewide_tests.find {|statewide_test| statewide_test.name == name.upcase}
  end

end
