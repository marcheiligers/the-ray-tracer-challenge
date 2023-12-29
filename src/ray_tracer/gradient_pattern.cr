module RayTracer
  class GradientPattern < Pattern
    getter :a, :b
    getter(distance : COLOR)

    def initialize(@a : COLOR, @b : COLOR, transform = Matrix::IDENTITY_4)
      super(transform)
      @distance = b - a
    end

    def initialize(a : Int32, b : Int32, transform = Matrix::IDENTITY_4)
      @a = color(a)
      @b = color(b)
      super(transform)
      @distance = @b - @a
    end

    def pattern_at(point : TUPLE)
      fraction = (point.x - point.x.floor).to_f32
      a + distance * fraction
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
