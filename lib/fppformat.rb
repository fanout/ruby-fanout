#    fppformat.rb
#    ~~~~~~~~~
#    This module implements the FppFormat class.
#    :authors: Konstantin Bokarius.
#    :copyright: (c) 2015 by Fanout, Inc.
#    :license: MIT, see LICENSE for more details.

require 'pubcontrol'

class FppFormat < Format
  def initialize(value)
    @value = value
  end

  def name
    return 'fpp'
  end

  def export
    return @value
  end
end
