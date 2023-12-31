module RayTracer
  class Computation
    include Tuple
    extend Tuple

    getter(t : Float64)
    getter(object : Shape)
    getter(point : TUPLE)
    getter(eyev : TUPLE)
    getter(normalv : TUPLE)
    getter(over_point : TUPLE)

    def initialize(intersection : Intersection, ray : Ray)
      @t = intersection.t
      @object = intersection.object

      @point = ray.position(t)
      @eyev = -ray.direction
      @normalv = object.normal_at(point)

      if dot(normalv, eyev) < 0
        @inside = true
        @normalv = -normalv
      else
        @inside = false
      end

      @over_point = point + normalv * EPSILON
    end

    def inside?
      @inside
    end
  end
end
