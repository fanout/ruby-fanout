#    fppformat.rb
#    ~~~~~~~~~
#    This module implements the FppFormat class.
#    :copyright: (c) 2014 by Konstantin Bokarius.
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
