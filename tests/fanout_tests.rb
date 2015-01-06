require 'fanout'

def callback(result, message)
  if !result
    puts 'Publish failed with message: ' + message.to_s
  end    
end

fanout = Fanout.new
fanout.publish('test', 'Test publish!')
index = 0
while index < 20 do
  fanout.publish_async('test', 'Test async publish!', nil, nil,
      method(:callback))
  index += 1
end
