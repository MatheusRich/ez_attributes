# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe EzAttributes do
  context 'when class has a single argument' do
    let(:single_arg_class) do
      Class.new do
        extend EzAttributes

        attribute :a
      end
    end

    it 'adds an initializer with a keyword argument' do
      obj = single_arg_class.new(a: 1)

      expect(obj).to be_instance_of single_arg_class
    end

    it 'adds an attribute accessor' do
      obj = single_arg_class.new(a: 1)

      expect(obj.a).to eq(1)
    end

    it 'requires args' do
      expect { single_arg_class.new }.to raise_error(ArgumentError, /missing keyword: :?a/)
    end

    it 'requires keyword args' do
      expect { single_arg_class.new(1) }.to raise_error(
        ArgumentError,
        /wrong number of arguments \(given 1, expected 0; required keyword: :?a\)/
      )
    end
  end

  context 'when class has multiple arguments' do
    let(:multiple_arg_class) do
      Class.new do
        extend EzAttributes

        attributes :a, :b
      end
    end

    it 'adds an initializer with keyword arguments' do
      parameters = multiple_arg_class.instance_method(:initialize).parameters

      expect(parameters).to eq([%i[keyreq a], %i[keyreq b]])
    end

    it 'adds attribute accessors', :aggregate_failures do
      obj = multiple_arg_class.new(a: 1, b: 2)

      expect(obj.a).to eq(1)
      expect(obj.b).to eq(2)
    end

    it 'requires args' do
      expect { multiple_arg_class.new }.to raise_error(ArgumentError, /missing keywords: :?a, :?b/)
    end

    it 'requires keyword args' do
      expect { multiple_arg_class.new(1, 2) }.to raise_error(
        ArgumentError,
        /wrong number of arguments \(given 2, expected 0; required keywords: a, b\)/
      )
    end
  end

  context 'with default values' do
    let(:class_with_default_values) do
      Class.new do
        extend EzAttributes

        attributes :a, b: :b, c: Time.now
      end
    end

    it 'only requires args without default values' do
      expect { class_with_default_values.new }.to raise_error(ArgumentError, /missing keyword: :?a/)
    end

    it 'adds the defaults to the constructor', :aggregate_failures do
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

    it 'does not break' do
      expect { class_with_default_values.new(class: Integer, if: true) }.not_to raise_error
    end
  end
end
