require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutArrays < Neo::Koan
  def test_creating_arrays
    empty_array = Array.new
    assert_equal Array, empty_array.class
    assert_equal 0, empty_array.size
    assert_equal [], empty_array
  end

  def test_array_literals
    array = Array.new
    assert_equal [], array

    array[0] = 1
    assert_equal [1], array

    array[1] = 2
    assert_equal [1, 2], array

    array << 333 #appends to the end of the array
    assert_equal [1, 2, 333], array
  end

  def test_accessing_array_elements
    array = [:peanut, :butter, :and, :jelly]

    assert_equal :peanut, array[0]
    assert_equal :peanut, array.first
    assert_equal :jelly, array[3]
    assert_equal :jelly, array.last
    assert_equal :jelly, array[-1]
    assert_equal :butter, array[-3]
    assert_equal nil, array[-5] #can go backwards until you are beyond the size
  end

  def test_slicing_arrays
    array = [:peanut, :butter, :and, :jelly]

    assert_equal [:peanut], array[0,1] # array[s, n] means; retrieve n elements from the array starting by the s'th position
    assert_equal [:peanut, :butter], array[0,2]
    assert_equal [:and, :jelly], array[2,2]
    assert_equal [:and, :jelly], array[2,20]
    assert_equal [], array[4,0]
    assert_equal [], array[4,100] # Slicing looks at arrays differently. Slice doesn't look at the identifying elements
                                  # instead looks at it like 0 :peanut 1 :butter 2 :and 3 :jelly 4, so 4 is valid, it just
                                  # has no elements after it to ever be retrieved
    assert_equal nil, array[5,0] #Anything beyond the length of the array will return nil
  end

  def test_arrays_and_ranges
    # a..b is like a <= x <= b, whereas a...b is like a <= x < b.
    assert_equal Range, (1..5).class
    assert_not_equal [1,2,3,4,5], (1..5)
    assert_equal 1..5, (1..5)
    assert_equal [1,2,3,4,5], (1..5).to_a
    assert_equal [1,2,3,4], (1...5).to_a
  end

  def test_slicing_with_ranges
    array = [:peanut, :butter, :and, :jelly]

    assert_equal [:peanut, :butter, :and], array[0..2]
    assert_equal [:peanut, :butter], array[0...2]
    assert_equal [:and, :jelly], array[2..-1] #Goes from slice index 2, then goes forward until it finds index -1
    assert_equal [:and], array[2..-2]
    assert_equal [], array[2..-3]
    assert_equal [], array[2..-4]
    assert_equal [], array[2..-5]
    assert_equal [], array[2..-6]
    assert_equal [:peanut, :butter, :and, :jelly], array[0..-1]
  end

  def test_pushing_and_popping_arrays
    array = [1,2]
    array.push(:last)

    assert_equal [1,2,:last], array

    popped_value = array.pop
    assert_equal :last, popped_value
    assert_equal [1,2], array
  end

  def test_shifting_arrays
    array = [1,2]
    array.unshift(:first) #unshift adds one or more elements to the beginning of the array
                          #returns the new length of the array

    assert_equal [:first,1,2], array

    shifted_value = array.shift #shift removes the first element of an array
                                #returns the removed element
    assert_equal :first, shifted_value
    assert_equal [1,2], array
    array.shift
    array.shift
    assert_equal [], array
    shifted_value = array.shift
    assert_equal nil, shifted_value #returns nil if the array was empty
    assert_equal [], array #Array itself just stays empty if shift is called on empty array
  end

end
