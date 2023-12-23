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

  module Expectations
    # Creates an `Expectation` that passes if actual is within *delta* of *expected*.
    def be_close(expected : RayTracer::Matrix, delta)
      Spec::MatrixCloseExpectation.new(expected, delta)
    end
  end
end
