require 'pry'
require_relative 'district'
require_relative 'enrollment_repository'

class DistrictRepository

  attr_accessor :districts, :enrollment_repo

  def initialize
    @districts = []
    @enrollment_repo = EnrollmentRepository.new
    load_data
  end

  def load_data
    #------test data
    e1 = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => { 2010 => 0.3805,
        2011 => 0.35456,
        2012 => 0.2687 },
      :high_school_graduation => { 2010 => 0.3434,
        2011 => 0.6845,
        2012 => 0.1123 }})
    e2 = Enrollment.new({:name => "GREEN MOUNTAIN",
      :kindergarten_participation => { 2010 => 0.5777,
        2011 => 0.8184,
        2012 => 0.5678 },
      :high_school_graduation => { 2010 => 0.7709,
        2011 => 0.657843845,
        2012 => 0.659 }})
    e3 = Enrollment.new({:name => "COLORADO",
      :kindergarten_participation => { 2010 => 0.41897,
        2011 => 0.76984,
        2012 => 0.3139 },
      :high_school_graduation => { 2010 => 0.1175,
        2011 => 0.613,
        2012 => 0.9358 }})
    enrollment_repo.enrollments = [e1, e2, e3]
    #-------------------
  end

  def enrollment_by_name(name)
    enrollment_repo.find_by_name(name)
  end

  def find_by_name(name)
    districts.select { |district| district.name == name.upcase }.pop
  end

  def find_all_matching(name)
    result = districts.select do |district|
      district.name.match(name.upcase) != nil
    end
  end

end
