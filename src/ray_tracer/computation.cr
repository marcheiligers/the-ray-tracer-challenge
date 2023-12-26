module RayTracer
  class Computation
    include Tuple
    extend Tuple

    getter(t : Float64)
    getter(object : Sphere)
    getter(point : TUPLE)
    getter(eyev : TUPLE)
    getter(normalv : TUPLE)

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
    end

    def inside?
      @inside
    end
  end
end
