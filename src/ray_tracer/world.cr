module RayTracer
  class World
    include Tuple
    extend Tuple
    extend Color

    getter(objects : Array(Sphere)) { [] of Sphere }
    property(light : PointLight) { PointLight::NIL }

    def self.default
      light = PointLight.new(point(-10, 10, -10), color(1, 1, 1))

      material = Material.new
      material.color = color(0.8, 1.0, 0.6)
      material.diffuse = 0.7
      material.specular = 0.2
      s1 = Sphere.new
      s1.material = material

      transform = Matrix.scaling(0.5, 0.5, 0.5)
      s2 = Sphere.new
      s2.transform = transform

      world = World.new
      world.light = light
      world.objects << s1 << s2
      world
    end

    def intersects(ray : Ray)
      intersections = Intersections.new
      objects.each { |o| intersections.concat(ray.intersects(o)) }
      intersections.sort_by!(&.t)
      intersections
    end

    def shade_hit(comps : Computation)
      raise "No light" if light.nil?

      comps.object.material.lighting(light, comps.point, comps.eyev, comps.normalv)
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
  end
end
