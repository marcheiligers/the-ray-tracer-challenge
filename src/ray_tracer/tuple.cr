module RayTracer
  module Tuple
    extend self

    alias TUPLE = NamedTuple(x: Float64, y: Float64, z: Float64, w: Float64)

    def point?(tuple : TUPLE)
      tuple[:w] == 1.0
    end

    def vector?(tuple : TUPLE)
      tuple[:w] == 0.0
    end

    def tuple(vals : Array(Float64))
      {x: vals[0], y: vals[1], z: vals[2], w: vals[3]}
    end

    def tuple(x : Float64, y : Float64, z : Float64, w : Float64)
      {x: x, y: y, z: z, w: w}
    end

    def point(x : Float64, y : Float64, z : Float64)
      tuple(x, y, z, 1.0)
    end

    def vector(x : Float64, y : Float64, z : Float64)
      tuple(x, y, z, 0.0)
    end

    def add(a1 : TUPLE, a2 : TUPLE)
      {x: a1[:x] + a2[:x], y: a1[:y] + a2[:y], z: a1[:z] + a2[:z], w: a1[:w] + a2[:w]}
    end

    def subtract(a1 : TUPLE, a2 : TUPLE)
      {x: a1[:x] - a2[:x], y: a1[:y] - a2[:y], z: a1[:z] - a2[:z], w: a1[:w] - a2[:w]}
    end

    def negate(a : TUPLE)
      {x: -a[:x], y: -a[:y], z: -a[:z], w: -a[:w]}
    end

    def multiply(a : TUPLE, s : Float64)
      {x: a[:x] * s, y: a[:y] * s, z: a[:z] * s, w: a[:w] * s}
    end

    def divide(a : TUPLE, s : Float64)
      {x: a[:x] / s, y: a[:y] / s, z: a[:z] / s, w: a[:w] / s}
    end

    def magnitude(a : TUPLE)
      Math.sqrt(a[:x] ** 2 + a[:y] ** 2 + a[:z] ** 2 + a[:w] ** 2)
    end

    def normalize(a : TUPLE)
      mag = magnitude(a)
      {x: a[:x] / mag, y: a[:y] / mag, z: a[:z] / mag, w: a[:w] / mag}
    end

    def dot(a1 : TUPLE, a2 : TUPLE)
      a1[:x] * a2[:x] + a1[:y] * a2[:y] + a1[:z] * a2[:z] + a1[:w] * a2[:w]
    end

    def cross(a1 : TUPLE, a2 : TUPLE)
      raise "Operands for cross are not both vectors" unless vector?(a1) && vector?(a2)
      vector(a1[:y] * a2[:z] - a1[:z] * a2[:y], a1[:z] * a2[:x] - a1[:x] * a2[:z], a1[:x] * a2[:y] - a1[:y] * a2[:x])
    end

    struct ::NamedTuple
      include RayTracer::Tuple

      def x
        raise "Don't know how to get x of #{typeof(self)}" unless typeof(self) == TUPLE
        self[:x]
      end

      def y
        raise "Don't know how to get y of #{typeof(self)}" unless typeof(self) == TUPLE
        self[:y]
      end

      def z
        raise "Don't know how to get z of #{typeof(self)}" unless typeof(self) == TUPLE
        self[:z]
      end

      def w
        raise "Don't know how to get w of #{typeof(self)}" unless typeof(self) == TUPLE
        self[:w]
      end

      def vector?
        raise "Don't know how to check if #{typeof(self)} is a vector" unless typeof(self) == TUPLE
        vector?(self)
      end

      def point?
        raise "Don't know how to check if #{typeof(self)} is a point" unless typeof(self) == TUPLE
        point?(self)
      end

      def +(other : TUPLE)
        raise "Don't know how to add #{typeof(self)} and #{typeof(other)}" unless typeof(self) == TUPLE
        add(self, other)
      end

      def -(other : TUPLE)
        raise "Don't know how to subtract #{typeof(self)} and #{typeof(other)}" unless typeof(self) == TUPLE
        subtract(self, other)
      end

      def - : self
        negate(self)
      end

      def *(scalar : Float64)
        raise "Don't know how to multiply #{typeof(self)} and #{typeof(scalar)}" unless typeof(self) == TUPLE
        multiply(self, scalar)
      end

      def /(scalar : Float64)
        raise "Don't know how to divide #{typeof(self)} and #{typeof(scalar)}" unless typeof(self) == TUPLE
        divide(self, scalar)
      end

      def magnitude
        raise "Don't know how to get the magnitude #{typeof(self)}" unless typeof(self) == TUPLE
        magnitude(self)
      end

      def normalize
        raise "Don't know how to normalize #{typeof(self)}" unless typeof(self) == TUPLE
        normalize(self)
      end

      def dot(other : TUPLE)
        raise "Don't know how to dot #{typeof(self)} and #{typeof(other)}" unless typeof(self) == TUPLE
        dot(self, other)
      end

      def cross(other : TUPLE)
        raise "Don't know how to cross #{typeof(self)} and #{typeof(other)}" unless typeof(self) == TUPLE
        cross(self, other)
      end
    end
  end
end
