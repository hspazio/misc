require 'minitest/autorun'
require_relative 'geopoint'
require_relative 'customer'
require_relative 'customer_invite_report'

class CustomerInviteReportTest < Minitest::Test
  def setup
    reference_geopoint = GeopointDegrees.new(53.3393, -6.2576841)
    @report            = CustomerInviteReport.new(reference_geopoint)
    @range_in_km       = 100
    Customer.store     = 'customers.txt'
  end

  def test_should_list_customers_within_range_with_name_and_id
    customers = @report.name_and_id_within_range(@range_in_km) 

    customers.each do |customer|
      assert !customer[:name].empty?
      assert customer[:id] > 0
    end
  end

  def test_should_list_customers_within_range_sorted_by_id
    customers = @report.name_and_id_within_range(@range_in_km)  

    customers.each_cons(2) do |cust_1, cust_2|
      assert cust_1[:id] < cust_2[:id]
    end
  end

  def test_should_list_no_customers_if_range_too_small
    assert_equal 0, @report.name_and_id_within_range(0).count 
  end
end

class CustomerTest < Minitest::Test
  def test_should_iterate_through_all_customers
    Customer.store = 'customers.txt'

    assert Customer.each.count > 0

    Customer.each do |customer|
      assert_kind_of Customer, customer
      assert customer.id
      assert !customer.name.empty?
      assert customer.geopoint
    end
  end

  def test_should_list_customers_within_geopoint_range_in_km
    Customer.store     = 'customers.txt'
    reference_geopoint = GeopointDegrees.new(53.3393, -6.2576841) 
    max_distance       = 100 

    customers = Customer.within_geopoint_range(reference_geopoint, max_distance)
    
    assert customers.any?
    customers.each do |customer|
      distance = customer.geopoint.distance_in_km(reference_geopoint)
      assert distance <= max_distance
    end
  end

  def test_should_raise_error_if_no_store_set
    Customer.store     = nil
    reference_geopoint = GeopointDegrees.new(53.3393, -6.2576841) 
    
    assert_raises Customer::StoreError do
      Customer.within_geopoint_range(reference_geopoint, 100)
    end
  end
end

class GeopointTest < Minitest::Test
  def test_should_convert_degrees_to_radians
    degrees_point = GeopointDegrees.new(53.3393, -6.2576841)

    radians_point = degrees_point.to_radians

    assert_in_delta 0.9309464057, radians_point.latitude, 1.0e-10
    assert_in_delta -0.109217191094, radians_point.longitude, 1.0e-10
  end

  def test_should_convert_radians_to_degrees
    radians_point = GeopointRadians.new(0.9309464057, -0.109217191094)

    degrees_point = radians_point.to_degrees
    
    assert_in_delta 53.3393, degrees_point.latitude, 0.0001
    assert_in_delta -6.2576841, degrees_point.longitude, 0.0001
  end

  def test_should_get_distance_between_points
    point_1 = GeopointDegrees.new(53.3393, -6.2576841)
    point_2 = GeopointDegrees.new(51.8856167, -10.4240951)

    distance = point_1.distance_in_km(point_2)

    assert_in_delta 324.36, distance, 0.01
  end

  def test_should_get_distance_between_points_without_converting_to_radians
    point_1 = GeopointDegrees.new(53.3393, -6.2576841).to_radians
    point_2 = GeopointDegrees.new(51.8856167, -10.4240951).to_radians

    distance = point_1.distance_in_km(point_2)

    assert_in_delta 324.36, distance, 0.01
  end
end
