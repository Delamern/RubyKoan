require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutObjects < Neo::Koan
  def test_everything_is_an_object
    assert_equal true, 1.is_a?(Object)
    assert_equal true, 1.5.is_a?(Object)
    assert_equal true, "string".is_a?(Object)
    assert_equal true, nil.is_a?(Object)
    assert_equal true, Object.is_a?(Object)
  end

  def test_objects_can_be_converted_to_strings
    assert_equal "123", 123.to_s #to_s returns a string representation of an object, usually a description.
                                 #to_str is actually stating the object behaves like a string
                                 #Can use duck typing to find out if something is a string by checking if it has the to_str method
    assert_equal "", nil.to_s #Returns an empty string. if we were to inspect, we get back nil which tells us what was actually there
  end

  def test_objects_can_be_inspected
    assert_equal "123", 123.inspect #Define to make a more developer-friendly version of to_s.
                                    #Include important debug info like variables for debugging purposes
    assert_equal "nil", nil.inspect
  end

  def test_every_object_has_an_id
    obj = Object.new
    assert_equal Integer, obj.object_id.class
  end

  def test_every_object_has_different_id
    obj = Object.new
    another_obj = Object.new
    assert_equal true, obj.object_id != another_obj.object_id
  end

  def test_small_integers_have_fixed_ids
    assert_equal 1, 0.object_id
    assert_equal 3, 1.object_id
    assert_equal 5, 2.object_id
    assert_equal 7, 3.object_id
    assert_equal 9, 4.object_id
    assert_equal 11, 5.object_id
    assert_equal 13, 6.object_id
    assert_equal 15, 7.object_id
    assert_equal 17, 8.object_id
    assert_equal 19, 9.object_id
    assert_equal 21, 10.object_id
    assert_equal 201, 100.object_id
    assert_equal 401, 200.object_id

    # THINK ABOUT IT:
    # What pattern do the object IDs for small integers follow?
  end

  def test_clone_creates_a_different_object
    obj = Object.new
    copy = obj.clone

    assert_equal true, obj           != copy
    assert_equal true, obj.object_id != copy.object_id
  end
end
