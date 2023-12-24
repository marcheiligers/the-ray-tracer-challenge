require "spec"
require "../src/requires"

module Spec
  struct MatrixCloseExpectation
    def initialize(@expected_value : RayTracer::Matrix, @delta : Float64)
    end

    def match(actual_value)
      @expected_value.rows.times do |r|
        @expected_value.cols.times do |c|
          return false unless (@expected_value[r, c] - actual_value[r, c]).abs <= @delta
        end
      end

      true
    end

    def failure_message(actual_value)
      "Expected #{actual_value.pretty_inspect} to be within #{@delta} of #{@expected_value.pretty_inspect}"
    end

    def negative_failure_message(actual_value)
      "Expected #{actual_value.pretty_inspect} not to be within #{@delta} of #{@expected_value.pretty_inspect}"
    end
  end

  struct TupleCloseExpectation
    def initialize(@expected_value : RayTracer::Tuple::TUPLE, @delta : Float64)
    end

    def match(actual_value)
      @expected_value.values.zip(actual_value.values) do |(e, a)|
        return false unless (e - a).abs <= @delta
      end

      true
    end

    def failure_message(actual_value)
      "Expected #{actual_value.pretty_inspect} to be within #{@delta} of #{@expected_value.pretty_inspect}"
    end

    def negative_failure_message(actual_value)
      "Expected #{actual_value.pretty_inspect} not to be within #{@delta} of #{@expected_value.pretty_inspect}"
    end
  end

  module Expectations
    # Creates an `Expectation` that passes if actual is within *delta* of *expected*.
    def be_close(expected : RayTracer::Matrix, delta)
      Spec::MatrixCloseExpectation.new(expected, delta)
    end

    # Creates an `Expectation` that passes if actual is within *delta* of *expected*.
    def be_close(expected : RayTracer::Tuple::TUPLE, delta)
      Spec::TupleCloseExpectation.new(expected, delta)
    end
  end
end
