require 'pry'
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 1a4468701af69f3f98020d3156b0f251807a099b
require_relative '../lib/data_manager'
require_relative '../lib/enrollment_repository'

class DistrictRepository
  attr_reader :data_manager, :enrollment_repo
  attr_accessor :districts

  def initialize
    @districts = []
    @data_manager = DataManager.new
    @enrollment_repo = EnrollmentRepository.new
  end

  def load_data(data)
    data_manager.load_data(data)
    populate_district_repo
    populate_enrollment_repo(data)

<<<<<<< HEAD
=======
    # binding.pry
>>>>>>> 1a4468701af69f3f98020d3156b0f251807a099b
    load_relationships
  end

  def load_relationships
    load_enrollments
  end

  def populate_district_repo
    @districts = data_manager.all_districts
  end

  def populate_enrollment_repo(data)
    @enrollment_repo.load_data(data)
  end

  def find_by_name(name)
    @districts.find { |district| district.name == name.upcase }
  end

  def find_all_matching(name)
    @districts.select { |district| district.name.include?(name.upcase) }
  end

  def load_enrollments
    @districts.each do |district|
      district.enrollment = @enrollment_repo.find_by_name(district.name)
<<<<<<< HEAD
=======
=======
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
    districts.find { |district| district.name == name.upcase }
  end

  def find_all_matching(name)
    districts.select do |district|
      district.name.match(name.upcase) != nil
>>>>>>> master
>>>>>>> 1a4468701af69f3f98020d3156b0f251807a099b
    end
  end

end
