require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/float'

class FloatTest < Minitest::Test

  def test_it_rounds_down_to_three_decimal_places
    x = 0.35789
    assert_equal 0.357, x.decimal_floor_3

    x = 5.7777777777
    assert_equal 5.777, x.decimal_floor_3
  end


end

if __FILE__ == $0
  puts "\n\n\n\ntest\n\n\n"
end
