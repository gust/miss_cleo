# MissCleo
![Miss Cleo](http://i.imgur.com/v4vmFtq.jpg)

Miss Cleo is a test failure predictor based on [Tenderlove's idea](http://tenderlovemaking.com/2015/02/13/predicting-test-failues.html). The idea is to give you a reasonable amount of confidence that your code changes are ok without having to run your full CI build.

## Requirements

Miss Cleo depends on Ruby 2.3.x (currently trunk Ruby) for its `Coverage.peek_result` functionality.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'miss_cleo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install miss_cleo

## Setup 

Right now Miss Cleo only supports Cucumber and RSpec tests. To use Miss Cleo:

### Cucumber
Before you can use Miss Cleo with your Cucumber tests, add the following line to your `support/env.rb` file:

```ruby
MissCleo::TestConfigurations::CucumberConfig.setup_hooks(self)
```

### Rspec
Before you can use Miss Cleo with your RSpec tests, add the following line to your `spec/spec_helper.rb` file:

```ruby
MissCleo::TestConfigurations::RspecConfig.setup_hooks(self)
```

### How to get predictin'

To use Miss Cleo, you'll need to first build a coverage diff of your *green* build. Do this by running your tests with the `COVERAGE` environment variable set to true.

Examples:

* `COVERAGE=true cucumber features/user.feature`
* `COVERAGE=true rspec spec/user_spec.rb`

With your coverage diffs built, you'll need to generate a coverage map, which we're calling a *deck*. To build your deck, run:
`miss_cleo build_deck <list of coverage diff files>`

## Usage

After you've made some code changes, run `miss_cleo predict` to be shown the relevant tests to run.

**Note**: Miss Cleo only tries to predict tests failures for uncommitted changes. Make sure your build is green before committing code!


## Known Oversights

Like the real Miss Cleo, we can't predict everything. Things we can't predict include:
- Rails views
- ActiveRecord methods
- ActiveRecord concerns
- Anything that generally runs only through gem code
- Any external library code

## Contributing

1. Fork it ( https://github.com/[my-github-username]/miss_cleo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
