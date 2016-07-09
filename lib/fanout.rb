#    fanout.rb
#    ~~~~~~~~~
#    This module implements the Fanout class.
#    :authors: Konstantin Bokarius.
#    :copyright: (c) 2015-2016 by Fanout, Inc.
#    :license: MIT, see LICENSE for more details.

require 'base64'
require 'thread'
require 'pubcontrol'
require_relative 'jsonobjectformat.rb'

# The Fanout class is used for publishing messages to Fanout.io and is
# configured with a Fanout.io realm and associated key. SSL can either
# be enabled or disabled. As a convenience, the realm and key
# can also be configured by setting the 'FANOUT_REALM' and 'FANOUT_KEY'
# environmental variables. Note that unlike the PubControl class
# there is no need to call the finish method manually, as it will
# automatically be called when the calling program exits.
class Fanout

  # Initialize with a specified realm, key, and a boolean indicating wther
  # SSL should be enabled or disabled. Note that if the realm and key 
  # are omitted then the initialize method will use the 'FANOUT_REALM'
  # and 'FANOUT_KEY' environmental variables.
  def initialize(realm=nil, key=nil, ssl=true)
    if realm.nil?
      realm = ENV['FANOUT_REALM']
    end
    if key.nil?
      key = ENV['FANOUT_KEY']
    end
    if ssl
      scheme = 'https'
    else
      scheme = 'http'
    end
    uri = '%s://api.fanout.io/realm/%s' % [scheme, realm]
    @pub = PubControl.new({'uri' => uri, 'iss' => realm,
        'key' => Base64.decode64(key)})
  end

  # Synchronously publish the specified data to the specified channel for
  # the configured Fanout.io realm. Optionally provide an ID and previous
  # ID to send along with the message.
  def publish(channel, data, id=nil, prev_id=nil)
    @pub.publish(channel, Item.new(JsonObjectFormat.new(data), id, prev_id))
  end

  # Asynchronously publish the specified data to the specified channel for
  # the configured Fanout.io realm. Optionally provide an ID and previous ID
  # to send along with the message, as well a callback method that will be
  # called after publishing is complete and passed the result and error message
  # if an error was encountered.
  def publish_async(channel, data, id=nil, prev_id=nil, callback=nil)
    @pub.publish_async(channel, Item.new(JsonObjectFormat.new(data), id,
        prev_id), callback)
  end
end
