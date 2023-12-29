module RayTracer
  class SolidPattern < Pattern
    getter :color

    def initialize(@color : COLOR, transform = Matrix::IDENTITY_4)
      super(transform)
    end

    def initialize(color : Int32, transform = Matrix::IDENTITY_4)
      @color = Color.color(color)
      super(transform)
    end

    def pattern_at(point : TUPLE)
      color
    end

    def ==(other : SolidPattern)
      color == other.color && transform == other.transform
    end

    def dup
      pattern = SolidPattern.new(color)
      pattern.transform = transform
      pattern
    end
  end
end
