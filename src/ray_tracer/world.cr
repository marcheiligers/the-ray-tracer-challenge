module RayTracer
  EPSILON = 0.00001

  class World
    include Tuple
    extend Tuple
    extend Color

    getter(objects : Array(Shape)) { [] of Shape }
    property(light : PointLight) { PointLight::NIL }

    def intersects(ray : Ray)
      intersections = Intersections.new
      objects.each { |o| intersections.concat(o.intersect(ray)) }
      intersections.sort_by!(&.t)
      intersections
    end

    def shade_hit(comps : Computation)
      raise "No light" if light.nil?

      comps.object.material.lighting(comps.object, light, comps.over_point, comps.eyev, comps.normalv, shadowed?(comps.over_point))
    end

    def color_at(ray : Ray)
      intersections = intersects(ray)
      if intersections.empty?
        Color::BLACK
      else
        i = intersections.hit
        if i.nil?
          Color::BLACK
        else
          comps = Computation.new(i, ray)
          shade_hit(comps)
        end
      end
    end

    def shadowed?(point : TUPLE)
      raise "Point should be a point" unless point.point?

      v = light.position - point
      distance = magnitude(v)
      direction = normalize(v)
      r = Ray.new(point, direction)
      intersections = intersects(r)
      h = intersections.hit
      !h.nil? && h.t < distance
    end
  end
end
