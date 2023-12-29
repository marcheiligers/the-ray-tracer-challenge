module RayTracer
  class BlendedPattern < Pattern
    getter :a, :b

    def initialize(@a : Pattern, @b : Pattern, transform = Matrix::IDENTITY_4)
      super(transform)
    end

    # def pattern_at(point : TUPLE)
    #   (a.pattern_at(point) + b.pattern_at(point)) / 2_f32
    # end

    def pattern_at_shape(object : Shape, world_point : TUPLE)
      object_point = object.inverse_transform * world_point
      pattern_point = inverse_transform * object_point
      # pattern_at(pattern_point)
      (a.pattern_at_shape(object, pattern_point) + b.pattern_at_shape(object, pattern_point)) / 2_f32
    end

    def ==(other : StripePattern)
      a == other.a && b == other.b && transform == other.transform
    end

    def dup
      BlendedPattern.new(a.dup, b.dup, transform.dup)
    end
  end
end
