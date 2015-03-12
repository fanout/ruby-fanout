#    fanout.rb
#    ~~~~~~~~~
#    This module implements the Fanout class.
#    :authors: Konstantin Bokarius.
#    :copyright: (c) 2015 by Fanout, Inc.
#    :license: MIT, see LICENSE for more details.

require 'base64'
require 'thread'
require 'pubcontrol'
require_relative 'jsonobjectformat.rb'

# The Fanout class is used for publishing messages to Fanout.io and is
# configured with a Fanout.io realm and associated key. SSL can either
# be enabled or disabled. As a convenience, the realm and key
# can also be configured by setting the 'FANOUT_REALM' and 'FANOUT_KEY'
# environmental variables.
class Fanout

  # Initialize with a specified realm, key, and a boolean indicating wther
  # SSL should be enabled or disabled. Note that if the realm and key 
  # are omitted then the initialize method will use the 'FANOUT_REALM'
  # and 'FANOUT_KEY' environmental variables. Note that unlike the PubControl
  # class there is no need to call the finish method manually, as it will
  # automatically be called when the calling program exits.
  def initialize(realm=nil, key=nil, ssl=true)
    if realm.nil?
      realm = ENV['FANOUT_REALM']
    end
    if key.nil?
      key = ENV['FANOUT_KEY']
    end
    @realm = realm
    @key = key
    @ssl = ssl
    at_exit { finish }
  end

  # Synchronously publish the specified data to the specified channel for
  # the configured Fanout.io realm. Optionally provide an ID and previous
  # ID to send along with the message.
  def publish(channel, data, id=nil, prev_id=nil)
    pub = get_pubcontrol
    pub.publish(channel, Item.new(JsonObjectFormat.new(data), id, prev_id))
  end

  # Asynchronously publish the specified data to the specified channel for
  # the configured Fanout.io realm. Optionally provide an ID and previous ID
  # to send along with the message, as well a callback method that will be
  # called after publishing is complete and passed the result and error message
  # if an error was encountered.
  def publish_async(channel, data, id=nil, prev_id=nil, callback=nil)
    pub = get_pubcontrol
    pub.publish_async(channel, Item.new(JsonObjectFormat.new(data), id,
        prev_id), callback)
  end

  private

  # An internal blocking method that calls the finish method on the PubControl
  # to ensure that all async publishing is completed before returning and
  # allowing the caller to proceed. Note that unlike the PubControl class
  # there is no need to call the finish method manually, as it will
  # automatically be called when the calling program exits.
  def finish
    pub = get_pubcontrol
    pub.finish
  end

  # An internal method used for retrieving the PubControl instance. The
  # PubControl instance is saved as a thread variable and if an instance
  # is not available when this method is called then one will be created.
  def get_pubcontrol
    if Thread.current['pubcontrol'].nil?
      if @ssl
        scheme = 'https'
      else
        scheme = 'http'
      end
      pub = PubControlClient.new(
          '%s://api.fanout.io/realm/%s' % [scheme, @realm])
      pub.set_auth_jwt({'iss' => @realm}, Base64.decode64(@key))
      Thread.current['pubcontrol'] = pub
    end
    return Thread.current['pubcontrol']
  end
end
