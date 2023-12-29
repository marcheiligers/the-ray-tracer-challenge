require "spec"
require "../src/requires"

module RayTracer
  class World
    def self.default
      light = PointLight.new(point(-10, 10, -10), color(1, 1, 1))

      material = Material.new
      material.pattern = SolidPattern.new(color(0.8, 1.0, 0.6))
      material.diffuse = 0.7
      material.specular = 0.2
      s1 = Sphere.new
      s1.material = material

      transform = Matrix.scaling(0.5, 0.5, 0.5)
      s2 = Sphere.new
      s2.transform = transform

      world = World.new
      world.light = light
      world.objects << s1 << s2
      world
    end
  end

  class TestShape < Shape
    getter(saved_ray : Ray?)

    def local_intersect(ray : Ray) : Intersections
      @saved_ray = ray
      Intersections.new
    end

    def local_normal_at(point : TUPLE)
      point
    end
  end

  class TestPattern < Pattern
    def pattern_at(point : TUPLE)
      color(point.x.to_f32, point.y.to_f32, point.z.to_f32)
    end

    def ==(other : Pattern)
      false
    end
  end
end

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

  struct ColorCloseExpectation
    def initialize(@expected_value : RayTracer::Color::COLOR, @delta : Float32)
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
