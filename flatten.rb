require 'minitest/autorun'

module Collection
  def self.flatten(array)  
    return [array] unless array.respond_to?(:each)
    array.inject([]){ |result, item| result += flatten(item) }
  end
end

class CollectionFlattenTest < Minitest::Test
  def test_should_flatten_array_of_integers
    assert_equal [1, 2, 3, 4], Collection.flatten([[1,2,[3]],4])
    assert_equal [1, 2, 3, 4], Collection.flatten([1,2,3,4])
    assert_equal [1], Collection.flatten([1])
    assert_equal [1,2,3,4,5,6,7], Collection.flatten([ 1, 2, [[ 3, 4 ],[ 5, 6 ], 7 ]])
    assert_equal [1, :a], Collection.flatten([[[[[[1], :a]]]]])
  end

  def test_should_flatten_empty_array
    assert_equal [], Collection.flatten([])
  end

  def test_should_flatten_array_with_nil_values
    assert_equal [1, nil, nil, 2], Collection.flatten([[1, [[nil, nil], 2]]])
  end

  def test_should_flatten_mixed_array_and_hashes
    input_array = [1, [:a, { name: 'fabio', surname: 'pitino' }], 3]
    expected_array = [1, :a, :name, 'fabio', :surname, 'pitino', 3]
    assert_equal expected_array, Collection.flatten(input_array)
  end
end
