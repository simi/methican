require './methic'
require 'minitest/autorun'

class MethicTest < Minitest::Test
  def parse(expr)
    @parser = Methic.parse(expr)
  end

  def test_number
    assert_equal 0, parse('0').eval
    assert_equal 1, parse('1').eval
    assert_equal 123, parse('123').eval
  end

  def test_variable
    assert_equal 0, parse('Xy1xY').eval('Xy1xY' => 0)
    assert_equal 10, parse('w1.ryba').eval('w1.ryba' => 10)
    assert_equal 3, parse('x').eval('x' => 3)
    assert_equal 10, parse('y').eval('y' => 10)
  end

  def test_formula
    assert_equal 64, parse('test1.ryba1 * (test1.ryba2 + 10)').eval('test1.ryba1' => 4, 'test1.ryba2' => 6)
  end

  def test_addition
    assert_equal 10, parse('x + 5').eval('x' => 5)
  end

  def test_subtraction
    assert_equal 0, parse('x - 5').eval('x' => 5)
  end

  def test_multiplication
    assert_equal 6, parse('x * 2').eval('x' => 3)
  end

  def test_division
    assert_equal 3, parse('x / 2').eval('x' => 6)
  end

  def test_order_of_operations
    assert_equal 11, parse('1 + 2 * 3 + 4').eval
  end

  def test_left_to_right
    assert_equal 2, parse('5 - 2 - 1').eval
  end

  def test_parentheses
    assert_equal 25, parse('(5 + x) * (10 - y)').eval('x' => 0, 'y' => 5)
  end
end
