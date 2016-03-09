require 'pry'
require_relative '../lib/data_manager'

class EnrollmentRepository
  attr_reader :data, :enrollments

  def initialize(enrollments = [])
    @enrollments = enrollments
  end

  def load_data(data)
    data_manager = DataManager.new
    data_manager.load_data(data)
    @enrollments = data_manager.create_enrollments
  end

  def find_by_name(name)
    @enrollments.find { |enrollment| enrollment.name == name.upcase }
  end
  
end
