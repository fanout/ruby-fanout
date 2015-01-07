#    jsonobjectformat.rb
#    ~~~~~~~~~
#    This module implements the JsonObjectFormat class.
#    :authors: Konstantin Bokarius.
#    :copyright: (c) 2015 by Fanout, Inc.
#    :license: MIT, see LICENSE for more details.

require 'pubcontrol'

class JsonObjectFormat < Format
  def initialize(value)
    @value = value
  end

  def name
    return 'json-object'
  end

  def export
    return @value
  end
end
