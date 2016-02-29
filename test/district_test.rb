require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district'

class DistrictTest < Minitest::Test

  def test_can_create_district_object
    district = District.new({:name => "ACADEMY 20"})

    assert_kind_of District, district
  end

  def test_name_returns_upcase_district_name
    district  = District.new({:name => "academy 20"})
    submitted = district.name
    expected  = "ACADEMY 20"

    assert_equal expected, submitted
  end

end
