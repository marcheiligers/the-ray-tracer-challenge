module RayTracer
  class CheckersPattern < Pattern
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
      (point.x.floor + point.y.floor + point.z.floor) % 2 == 0.0 ? a.pattern_at(point) : b.pattern_at(point)
    end

    def ==(other : CheckersPattern)
      a == other.a && b == other.b && transform == other.transform
    end

    def dup
      pattern = CheckersPattern.new(a, b)
      pattern.transform = transform
      pattern
    end
  end
end
