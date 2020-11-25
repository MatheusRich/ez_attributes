<p align="center">
  <h1 align="center">EzAttributes</h1>

  <p align="center">
    <i>Easily define initializers with keyword args</i>
    <br>
    <br>
    <img src="https://img.shields.io/gem/v/ez_attributes">
    <img src="https://img.shields.io/gem/dt/ez_attributes">
    <img src="https://github.com/MatheusRich/ez_attributes/workflows/Ruby/badge.svg">
    <a href="https://github.com/MatheusRich/ez_attributes/blob/master/LICENSE">
      <img src="https://img.shields.io/github/license/MatheusRich/ez_attributes.svg" alt="License">
    </a>
  </p>
</p>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ez_attributes'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ez_attributes

## Usage

The first step is to extend EzAttributes in your class.

```ruby
class User
  extend EzAttributes
end
```

Then, add the required and optional fields

```ruby
class User
  extend EzAttributes

  # Here name and age are required, and email has a default value, so it is optional.
  attributes :name, :age, email: 'guest@user.com'
end

User.new(name: 'Matz', age: 22)
# => #<User:0x000055bac152f130 @name="Matz", @age=22, @email="guest@user.com">

# EzAttributes will add getters for all fields too.
User.name
# => "Matz"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MatheusRich/ez_attributes.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
