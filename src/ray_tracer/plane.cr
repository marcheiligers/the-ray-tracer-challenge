module RayTracer
  class Plane < Shape
    NORMAL = Tuple.vector(0, 1, 0)

    def local_intersect(ray : Ray) : Intersections
      return Intersections.new if ray.direction.y.abs < EPSILON

      t = -ray.origin.y / ray.direction.y
      Intersections.new(Intersection.new(t, self))
    end

    def local_normal_at(point : TUPLE)
      NORMAL
    end
  end
end
