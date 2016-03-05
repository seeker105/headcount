require 'pry'

class District
  attr_accessor :enrollment, :statewide_test
  attr_reader :name

  def initialize(name_hash)
    @name = name_hash[:name].upcase
  end

end
