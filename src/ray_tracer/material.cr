module RayTracer
  class Material
    include Color
    include Tuple

    property(pattern : Pattern)
    property(ambient : Float32)
    property(diffuse : Float32)
    property(specular : Float32)
    property(shininess : Float32)

    def initialize(@pattern : Pattern = SolidPattern.new(WHITE), @ambient = 0.1_f32, @diffuse = 0.9_f32, @specular = 0.9_f32, @shininess = 200.0_f32)
    end

    def ==(other)
      ambient == other.ambient &&
        diffuse == other.diffuse &&
        specular == other.specular &&
        shininess == other.shininess &&
        pattern == other.pattern
    end

    def dup(deep = false)
      material = Material.new
      material.ambient = ambient
      material.diffuse = diffuse
      material.specular = specular
      material.shininess = shininess
      material.pattern = deep ? pattern : pattern.dup
      material
    end

    def lighting(object, light, point, eyev, normalv, in_shadow = false)
      # combine the surface color with the light's color/intensity
      effective_color = pattern.pattern_at_shape(object, point) * light.intensity
      # find the direction to the light source
      lightv = normalize(light.position - point) # compute the ambient contribution
      ambient = effective_color * self.ambient
      return ambient if in_shadow

      # light_dot_normal represents the cosine of the angle between the
      # light vector and the normal vector. A negative number means the
      # light is on the other side of the surface.
      light_dot_normal = dot(lightv, normalv)
      if light_dot_normal < 0
        diffuse = BLACK
        specular = BLACK
      else
        # compute the diffuse contribution
        diffuse = effective_color * self.diffuse * light_dot_normal.to_f32
        # reflect_dot_eye represents the cosine of the angle between the
        # reflection vector and the eye vector. A negative number means the
        # light reflects away from the eye.
        reflectv = reflect(-lightv, normalv)
        reflect_dot_eye = dot(reflectv, eyev)

        if reflect_dot_eye <= 0
          specular = BLACK
        else
          # compute the specular contribution
          factor = (reflect_dot_eye ** self.shininess).to_f32
          specular = light.intensity * self.specular * factor
        end
      end

      # Add the three contributions together to get the final shading
      ambient + diffuse + specular
    end
  end
end
