require 'fanout'
require 'thread'
require 'base64'
require 'minitest/autorun'

class PubControlTestClass
  attr_accessor :was_finish_called
  attr_accessor :publish_channel
  attr_accessor :publish_item
  attr_accessor :publish_callback

  def initialize
    @was_finish_called = false
    @publish_channel = nil
    @publish_item = nil
    @publish_callback = nil
  end

  def finish
    @was_finish_called = true
  end

  def publish(channel, item)
    @publish_channel = channel
    @publish_item = item
  end

  def publish_async(channel, item, callback=nil)
    @publish_channel = channel
    @publish_item = item
    @publish_callback = callback
  end
end

class TestFanout < Minitest::Test
  def setup
    ENV['FANOUT_REALM'] = nil
    ENV['FANOUT_KEY'] = nil
    Thread.current['pubcontrol'] = nil
  end

  def test_initialize_without_params
    fo = Fanout.new
    assert_equal(fo.instance_variable_get(:@realm), nil)
    assert_equal(fo.instance_variable_get(:@key), nil)
    assert_equal(fo.instance_variable_get(:@ssl), true)
  end

  def test_initialize_with_params
    fo = Fanout.new('realm', 'key', 'ssl')
    assert_equal(fo.instance_variable_get(:@realm), 'realm')
    assert_equal(fo.instance_variable_get(:@key), 'key')
    assert_equal(fo.instance_variable_get(:@ssl), 'ssl')
  end

  def test_initialize_env_params
    ENV['FANOUT_REALM'] = 'env_realm'
    ENV['FANOUT_KEY'] = 'env_key'
    fo = Fanout.new
    assert_equal(fo.instance_variable_get(:@realm), 'env_realm')
    assert_equal(fo.instance_variable_get(:@key), 'env_key')
    assert_equal(fo.instance_variable_get(:@ssl), true)
  end

  def test_get_pubcontrol_existing
    orig_pc = PubControl.new
    Thread.current['pubcontrol'] = orig_pc
    fo = Fanout.new('realm', 'key', 'ssl')    
    pc = fo.send(:get_pubcontrol)
    assert_equal(pc, orig_pc)
  end

  def test_get_pubcontrol_new_http
    fo = Fanout.new('realm', 'key', false)    
    pc = fo.send(:get_pubcontrol)
    assert_equal(pc.instance_variable_get(:@auth_jwt_claim),
        { 'iss' => 'realm'})
    assert_equal(pc.instance_variable_get(:@auth_jwt_key),
        Base64.decode64('key'))
    assert_equal(pc.instance_variable_get(:@uri),
        'http://api.fanout.io/realm/realm')
  end

  def test_get_pubcontrol_new_https
    fo = Fanout.new('realm', 'key', true)    
    pc = fo.send(:get_pubcontrol)
    assert_equal(pc.instance_variable_get(:@auth_jwt_claim),
        { 'iss' => 'realm'})
    assert_equal(pc.instance_variable_get(:@auth_jwt_key),
        Base64.decode64('key'))
    assert_equal(pc.instance_variable_get(:@uri),
        'https://api.fanout.io/realm/realm')
  end

  def test_finish
    fo = Fanout.new('realm', 'key', true)
    pc = PubControlTestClass.new
    Thread.current['pubcontrol'] = pc
    fo.send(:finish)
    assert(pc.was_finish_called)
  end

  def test_publish
    fo = Fanout.new('realm', 'key', true)
    pc = PubControlTestClass.new
    Thread.current['pubcontrol'] = pc
    fo.publish('channel', 'item')
    assert_equal(pc.publish_channel, 'channel')
    assert_equal(pc.publish_item.export, 
        Item.new(JsonObjectFormat.new('item')).export)
  end

  def test_publish_async_without_callback
    fo = Fanout.new('realm', 'key', true)
    pc = PubControlTestClass.new
    Thread.current['pubcontrol'] = pc
    fo.publish_async('channel', 'item')
    assert_equal(pc.publish_channel, 'channel')
    assert_equal(pc.publish_item.export, 
        Item.new(JsonObjectFormat.new('item')).export)
    assert_equal(pc.publish_callback, nil)
  end

  def callback_for_testing(result, error)
    assert_equal(@has_callback_been_called, false)
    assert_equal(result, false)
    assert_equal(error, 'error')
    @has_callback_been_called = true
  end

  def test_publish_async_with_callback
    @has_callback_been_called = false
    fo = Fanout.new('realm', 'key', true)
    pc = PubControlTestClass.new
    Thread.current['pubcontrol'] = pc
    fo.publish_async('channel', 'item', 'id', 'prev-id', 
        method(:callback_for_testing))
    assert_equal(pc.publish_channel, 'channel')
    assert_equal(pc.publish_item.export,
        Item.new(JsonObjectFormat.new('item'), 'id', 'prev-id').export)
    pc.publish_callback.call(false, 'error')
    assert(@has_callback_been_called)
  end
end
