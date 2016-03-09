require 'pry'

class Float

  def decimal_floor_3
    (self * 1000).floor / 1000.0
  end

end
