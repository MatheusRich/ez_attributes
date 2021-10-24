# frozen_string_literal: true

module EzAttributes
  # Config for EzAttributes
  # @example
  # class User
  #   extend EzAttributes.configure(getters: false)
  #
  #   attributes :name, :age
  # end
  #
  # user = User.new(name: 'Matz', age: 22)
  # p user.name
  #   => `<main>': undefined method `name' for #<User:0x000055a07f700f60 @name="Matz", @age=22> (NoMethodError)
  class Config
    attr_reader :getters

    def initialize(getters: true)
      @getters = getters
    end
  end
end
