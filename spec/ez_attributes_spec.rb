# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe EzAttributes do
  context "when class has a single argument" do
    let(:single_arg_class) do
      Class.new do
        extend EzAttributes

        attribute :a
      end
    end

    it "adds an initializer with a keyword argument" do
      obj = single_arg_class.new(a: 1)

      expect(obj).to be_instance_of single_arg_class
    end

    it "adds an attribute accessor" do
      obj = single_arg_class.new(a: 1)

      expect(obj.a).to eq(1)
    end

    it "requires args" do
      expect { single_arg_class.new }.to raise_error(ArgumentError, /missing keyword: :?a/)
    end

    it "requires keyword args" do
      expect { single_arg_class.new(1) }.to raise_error(
        ArgumentError,
        /wrong number of arguments \(given 1, expected 0; required keyword: :?a\)/
      )
    end
  end

  context "when class has a single argument with a default value" do
    let(:single_arg_class) do
      Class.new do
        extend EzAttributes

        attribute a: 33
      end
    end

    it "adds an initializer with a keyword argument" do
      obj = single_arg_class.new(a: 1)

      expect(obj).to be_instance_of single_arg_class
    end

    it "adds an attribute accessor" do
      obj = single_arg_class.new(a: 1)

      expect(obj.a).to eq(1)
    end

    it "uses the default value" do
      obj = single_arg_class.new

      expect(obj.a).to eq(33)
    end

    it "requires keyword args" do
      expect { single_arg_class.new(1) }.to raise_error(
        ArgumentError,
        /wrong number of arguments \(given 1, expected 0\)/
      )
    end
  end

  context "when class has a single argument with different of one default value" do
    let(:single_arg_class) do
      Class.new do
        extend EzAttributes

        attribute a: 33, b: 35
      end
    end

    it "requires just one attribute" do
      expect { single_arg_class.new(a: 1, b: 2) }.to raise_error(
        ArgumentError,
        /wrong number of arguments \(given 2, expected 1\)/
      )
    end
  end

  context "when class has multiple arguments" do
    let(:multiple_arg_class) do
      Class.new do
        extend EzAttributes

        attributes :a, :b
      end
    end

    it "adds an initializer with keyword arguments" do
      parameters = multiple_arg_class.instance_method(:initialize).parameters

      expect(parameters).to eq([%i[keyreq a], %i[keyreq b]])
    end

    it "adds attribute accessors", :aggregate_failures do
      obj = multiple_arg_class.new(a: 1, b: 2)

      expect(obj.a).to eq(1)
      expect(obj.b).to eq(2)
    end

    it "requires args" do
      expect { multiple_arg_class.new }.to raise_error(ArgumentError, /missing keywords: :?a, :?b/)
    end

    it "requires keyword args" do
      expect { multiple_arg_class.new(1, 2) }.to raise_error(
        ArgumentError,
        /wrong number of arguments \(given 2, expected 0; required keywords: a, b\)/
      )
    end
  end

  context "with default values" do
    let(:class_with_default_values) do
      Class.new do
        extend EzAttributes

        attributes :a, b: :b, c: Time.now
      end
    end

    it "only requires args without default values" do
      expect { class_with_default_values.new }.to raise_error(ArgumentError, /missing keyword: :?a/)
    end

    it "adds the defaults to the constructor", :aggregate_failures do
      obj = class_with_default_values.new(a: 0)

      expect(obj.a).to eq(0)
      expect(obj.b).to eq(:b)
      expect(obj.c).to be_a Time
    end
  end

  context "when arg names match ruby's reserved words" do
    let(:class_with_default_values) do
      Class.new do
        extend EzAttributes

        attributes :class, :if
      end
    end

    it "does not break" do
      expect { class_with_default_values.new(class: Integer, if: true) }.not_to raise_error
    end

    it "does not add attr_reader for :class attribute", :aggregate_failures do
      obj = class_with_default_values.new(class: Integer, if: true)
      expect(obj.class).not_to eq Integer
      expect(obj.if).to eq true
    end
  end

  context "when an instance mutates state" do
    let(:test_class) do
      Class.new do
        extend EzAttributes

        attributes a: []

        def change_attr
          a << 1
        end
      end
    end

    it "does not share state with other instances", :aggregate_failures do
      obj1 = test_class.new
      obj1.change_attr
      obj1.change_attr

      obj2 = test_class.new
      obj2.change_attr

      expect(obj1.a).to eq [1, 1]
      expect(obj2.a).to eq [1]
    end
  end

  context "when config is not present" do
    let(:test_class) do
      Class.new do
        extend EzAttributes

        attributes :test
      end
    end

    it "defines getters" do
      expect { test_class.new(test: "test").test }.not_to raise_error
    end
  end

  context "when config is present and has getters: true" do
    let(:test_class) do
      Class.new do
        extend EzAttributes.configure(getters: true)

        attributes :test
      end
    end

    it "defines getters" do
      expect { test_class.new(test: "test").test }.not_to raise_error
    end
  end

  context "when config is present and has getters: false" do
    let(:test_class) do
      Class.new do
        extend EzAttributes.configure(getters: false)

        attributes :test
      end
    end

    it "does not define getters" do
      expect { test_class.new(test: "test").test }.to raise_error NoMethodError
    end
  end
end
