require 'pry'
require_relative '../lib/data_manager'

class StatewideTestRepository
  attr_reader :statewide_tests

  def initialize(data = {})
    @statewide_tests = load_data(data)
  end

  def load_data(data)
    data_manager = DataManager.new
    data_manager.load_data(data)
    populate_repo(data_manager.create_statewide_tests)
  end

  def populate_repo(raw_stw_tests)
    @statewide_tests = raw_stw_tests.each_with_object({}) do |stw_test, object|
      object[stw_test.name] = stw_test
    end
  end

  def find_by_name(name)
    @statewide_tests[name.upcase]
  end

end
