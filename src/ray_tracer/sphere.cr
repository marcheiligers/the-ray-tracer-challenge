module RayTracer
  class Sphere < Shape
    def local_intersect(ray : Ray) : Intersections
      sphere_to_ray = ray.origin - ORIGIN
      a = dot(ray.direction, ray.direction)
      b = 2 * dot(ray.direction, sphere_to_ray)
      c = dot(sphere_to_ray, sphere_to_ray) - 1
      discriminant = b * b - 4 * a * c

      return Intersections.new if discriminant < 0

      Intersections.new(
        Intersection.new((-b - Math.sqrt(discriminant)) / (2 * a), self),
        Intersection.new((-b + Math.sqrt(discriminant)) / (2 * a), self),
      )
    end

    def local_normal_at(point : TUPLE)
      point - ORIGIN
    end
  end
end
