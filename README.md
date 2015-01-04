ruby-fanout
===========

Author: Konstantin Bokarius <bokarius@comcast.net>
Mailing List: http://lists.fanout.io/listinfo.cgi/fanout-users-fanout.io

A Ruby convenience library using the EPCP protocol to publish FPP format messages for Fanout.io.

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

fanout = Fanout.new('<myrealm>', '<myrealmkey>')
fanout.publish('test', 'Test publish!\n')
fanout.publish_async('test', 'Test async publish!\n', method(:callback))
```
