#    fanout.rb
#    ~~~~~~~~~
#    This module implements the Fanout class.
#    :copyright: (c) 2014 by Fanout.io.
#    :license: MIT, see LICENSE for more details.

require 'base64'
require 'thread'
require 'pubcontrol'
require_relative 'fppformat.rb'

class Fanout
  def initialize(realm, key, ssl=true)
    @realm = realm
    @key = key
    @ssl = ssl
  end

  def publish(channel, data, id=nil, prev_id=nil)
    pub = get_pubcontrol
    pub.publish(channel, Item.new(FppFormat.new(data), id, prev_id))
  end

  def publish_async(channel, data, id=nil, prev_id=nil, callback=nil)
    pub = get_pubcontrol
    pub.publish_async(channel, Item.new(FppFormat.new(data), id, prev_id),
        callback)
  end

  private

  def get_pubcontrol
    if Thread.current['pubcontrol'].nil?
      if @ssl
        scheme = 'https'
      else
        scheme = 'http'
      end
      pub = PubControl.new('%s://api.fanout.io/realm/%s' % [scheme, @realm])
      pub.set_auth_jwt({'iss' => @realm}, Base64.decode64(@key))
      Thread.current['pubcontrol'] = pub
    end
    return Thread.current['pubcontrol']
  end
end
