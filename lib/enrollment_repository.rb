require 'pry'
<<<<<<< HEAD
require 'csv'
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

=======

require_relative 'enrollment'

class EnrollmentRepository

  attr_accessor :enrollments

  def initialize
    @enrollments = []
  end

  def find_by_name(name)
    enrollments.find{ |enrollment| enrollment.name == name.upcase }
  end


end



if __FILE__ == $0
  # puts "XXXXXXXXX"
  e1 = Enrollment.new({:name => "ACADEMY 20",
                       :kindergarten_participation => { 2010 => 0.3915,
                                                        2011 => 0.35356,
                                                        2012 => 0.2677 }})
  e2 = Enrollment.new({:name => "GREEN MOUNTAIN",
                       :kindergarten_participation => { 2010 => 0.5777,
                                                        2011 => 0.8184,
                                                        2012 => 0.5678 }})
  enroll_repos = EnrollmentRepository.new
  enroll_repos.enrollments = [e1, e2]
  binding.pry
>>>>>>> master
end
