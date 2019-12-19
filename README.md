# MidgetJobs

MidgetJobs is simple implementation of background jobs for [Ruby on Rails](https://rubyonrails.org). I does not meant to be used without it.
It is connected to [ActiveJob](https://github.com/rails/rails/tree/master/activejob) and [PostgreSQL](https://www.postgresql.org) using its triggers, notifications and listening.

## Update from 0.1.7 to 0.2.0
There is new column **runner** in **midget_jobs** table!
It is used to recognise who will run particular job (if there are multiple application over one database)

I added new configuration to Initializer. Add this to your config/initializers/midget_jobs.rb
```Rails.application.config.x.midget_jobs.runner = Rails.application.class.parent_name```

Please create migration with generator
```rails generate migration AddRunnerToMidgetJob runner:string:index``` 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'midget_jobs'
```

And then execute:

    $ bundle
    
Then run    

    $ rails generate midget_jobs:install
    
This generator creates an initializer file at config/initializers and migrations to db/migrate
      
## Usage

Just use [ActiveJob](https://github.com/rails/rails/tree/master/activejob) as described in [Guides](https://guides.rubyonrails.org/active_job_basics.html) 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jchsoft/midget_jobs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MidgetJob project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/midget_job/blob/master/CODE_OF_CONDUCT.md).
