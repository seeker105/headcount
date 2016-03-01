require 'pry'

class EnrollmentRepository
  attr_reader :enrollment_data

  def load(enrollment_data)
    @enrollment_data = enrollment_data

  end

  def find_by_name(name)
    # case insensitive search
    # returns enrollment object
    # else returns nil
  end


end
