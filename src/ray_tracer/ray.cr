module RayTracer
  class Ray
    include Tuple

    getter :origin, :direction

    def initialize(@origin : TUPLE, @direction : TUPLE)
      raise "Origin must be a point not #{@origin}" unless point?(@origin)
      raise "Direction must be a vector not #{@direction}" unless vector?(@direction)
    end

    def position(t : Float64)
      @origin + @direction * t
    end

    def transform(m : Matrix)
      Ray.new(m * @origin, m * @direction)
    end
  end
end
