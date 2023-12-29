module RayTracer
  class RingPattern < Pattern
    getter :a, :b

    def initialize(a : COLOR, b : COLOR, transform = Matrix::IDENTITY_4)
      @a = SolidPattern.new(a)
      @b = SolidPattern.new(b)
      super(transform)
    end

    def initialize(a : Int32, b : Int32, transform = Matrix::IDENTITY_4)
      @a = SolidPattern.new(a)
      @b = SolidPattern.new(b)
      super(transform)
    end

    def initialize(@a : Pattern, @b : Pattern, transform = Matrix::IDENTITY_4)
      super(transform)
    end

    def pattern_at(point : TUPLE)
      Math.sqrt(point.x**2 + point.z**2).floor.to_i32.even? ? a.pattern_at(point) : b.pattern_at(point)
    end

    def ==(other : StripePattern)
      a == other.a && b == other.b && transform == other.transform
    end

    def dup
      pattern = StripePattern.new(a, b)
      pattern.transform = transform
      pattern
    end
  end
end
