require 'pry'


class District

  def initialize(name_hash)
    @name_hash = name_hash
  end

  def name
    @name_hash[:name].upcase
  end


end
