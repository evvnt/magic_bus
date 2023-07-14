# MagicBus

The Magic Bus sends messages between two or more ruby applications using an event bus 
built on top of a AWS SNS Topic and SQS Queues.

This event bus allows you to to broadcast change messages between multiple applications and keep them in sync.

[![Magic Bus](img/magic_bus.jpg)](https://www.youtube.com/watch?v=bl9bvuAV-Ao)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'magic_bus'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install magic_bus

## Configuration

As a developer, you will need your own event bus built using the 
[event-bus-provision](https://github.com/evvnt/CloudTools/actions/workflows/event-bus-provision.yml) Github Action.

Suggestion use your name as the bus_name.

Setup the following env variables using the output from the above action:
```
export MAGIC_BUS_BUS_NAME=<bus_name>
export MAGIC_BUS_APP_NAME=<app_name>
export MAGIC_BUS_AWS_ACCOUNT_ID=<aws_account_id>
export MAGIC_BUS_AWS_ACCESS_KEY_ID=<access_key_id>
export MAGIC_BUS_AWS_SECRET_ACCESS_KEY="<aws_secret_access_key>"
export MAGIC_BUS_AWS_REGION=us-east-2
```

## Publishing Messages

```
MagicBus.publish(event: "MagicBus::TestEvent", message: {test: "message"})
```

## Receiving Messages
To Receive messages you need to start the `magic_bus` process. 
It in turns starts up a single shoryuken worker that processes messages.
Each message received needs to have a class that matches the event.
When that event occurs the class is instantiated and its process method is called with the message.

For example, we can process the test event above like so:
```ruby
module MagicBus
  class TestEvent
    def perform(_sqs_msg, msg)
      # Take action - msg = {test: "message"} in this case
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/evvnt/magic_bus.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
