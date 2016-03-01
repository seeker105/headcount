require 'pry'

class DistrictRepository

  attr_accessor :districts

  def initialize
    @districts = []
  end

  def load_data(data_file_hash)


  end

  def find_by_name(name)
    result = districts.select { |district| district.name == name.upcase }
    if result == []
      result = nil
    end
    result
  end

  def find_all_matching(name)
    result = districts.select do |district|
      district.name.match(name.upcase) != nil
    end
  end

end
