ruby-fanout
===========

Author: Konstantin Bokarius <kon@fanout.io>

A Ruby convenience library for publishing FPP format messages to Fanout.io using the EPCP protocol.

License
-------

ruby-fanout is offered under the MIT license. See the LICENSE file.

Installation
------------

```sh
gem install fanout
```

Usage
-----

```Ruby
require 'fanout'

def callback(result, message)
  if result
    puts 'Publish successful'
  else
    puts 'Publish failed with message: ' + message.to_s
  end
end

# Omitting the realm and key arguments causes Fanout to use
# the FANOUT_REALM and FANOUT_KEY environmental variables.
fanout = Fanout.new

# Alternatively specify the realm and/or key.
fanout = Fanout.new('<myrealm>', '<myrealmkey>')

fanout.publish('<channel>', 'Test publish!')
fanout.publish_async('<channel>', 'Test async publish!',
    nil, nil, method(:callback))
```
