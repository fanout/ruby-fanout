#    jsonobjectformat.rb
#    ~~~~~~~~~
#    This module implements the JsonObjectFormat class.
#    :authors: Konstantin Bokarius.
#    :copyright: (c) 2015 by Fanout, Inc.
#    :license: MIT, see LICENSE for more details.

require 'pubcontrol'

# The JSON object format used for publishing messages to Fanout.io.
class JsonObjectFormat < Format

  # Initialize with a value representing the message to be sent.
  def initialize(value)
    @value = value
  end

  # The name of the format.
  def name
    return 'json-object'
  end

  # The method used to export the format data.
  def export
    return @value
  end
end
