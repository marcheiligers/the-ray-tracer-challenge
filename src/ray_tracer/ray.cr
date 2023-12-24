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

    def intersects(s : Sphere) : Intersections
      sphere_to_ray = @origin - point(0, 0, 0)
      a = dot(@direction, @direction)
      b = 2 * dot(@direction, sphere_to_ray)
      c = dot(sphere_to_ray, sphere_to_ray) - 1
      discriminant = b * b - 4 * a * c

      return Intersections.new if discriminant < 0

      Intersections.new(
        Intersection.new((-b - Math.sqrt(discriminant)) / (2 * a), s),
        Intersection.new((-b + Math.sqrt(discriminant)) / (2 * a), s),
      )
    end
  end
end
