require 'jsonobjectformat'
require 'minitest/autorun'

class TestJsonObjectFormat < Minitest::Test
  def test_initialize
    format = JsonObjectFormat.new('value')
    assert_equal(format.instance_variable_get(:@value), 'value');
  end

  def test_name
    format = JsonObjectFormat.new('value')
    assert_equal(format.name, 'json-object');
  end

  def test_export
    format = JsonObjectFormat.new('value')
    assert_equal(format.export, 'value');
  end
end
