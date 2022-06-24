# Stash::Rewards

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/stash/rewards`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stash-rewards'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install stash-rewards --pre

## Usage

```ruby
require 'stash/rewards'

config = Stash::Rewards::Config.new(api_key: '', authorization: '', api_domain: '')

campaign_id = ''
user_identifier = ''
reward_id = ''

rwds_api = Stash::Rewards::GetRewards.new(config)
rwds_api.call(campaign_id: campaign_id, page_no: 0, page_size: 10)

create_user_api = Stash::Rewards::CreateUser.new(config)
create_user_api.call(user_identifier: user_identifier)

enrol_user_api = Stash::Rewards::EnrolUserInCampaign.new(config)
enrol_user_api.call(campaign_id: campaign_id, user_identifier: user_identifier)

issue_voucher = Stash::Rewards::IssueVoucher.new(config)
issue_voucher.call(campaign_id: campaign_id, user_identifier: user_identifier, reward_id: reward_id)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/PerxTech/stash-rewards. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/PerxTech/stash-rewards/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Stash::Rewards project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/PerxTech/stash-rewards/blob/master/CODE_OF_CONDUCT.md).
