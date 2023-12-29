module RayTracer
  class Shape
    include Tuple

    getter(transform : Matrix)
    getter(inverse_transform : Matrix)
    getter(transpose_inverse_transform : Matrix)
    property(material)

    def initialize(@transform = Matrix::IDENTITY_4, @material = Material.new)
      @inverse_transform = @transform.inverse
      @transpose_inverse_transform = @inverse_transform.transpose
    end

    def transform=(val : Matrix)
      @transform = val
      @inverse_transform = val.inverse
      @transpose_inverse_transform = @inverse_transform.transpose
    end

    def intersect(ray : Ray) : Intersections
      local_intersect(ray.transform(inverse_transform))
    end

    def local_intersect(ray : Ray) : Intersections
      raise NotImplementedError.new("#local_intersect must be implemented by subsclasses of Shape")
    end

    def normal_at(point : TUPLE)
      local_point = inverse_transform * point
      local_normal = local_normal_at(local_point)
      world_normal = transpose_inverse_transform * local_normal
      vector(world_normal.x, world_normal.y, world_normal.z).normalize
    end

    def local_normal_at(point : TUPLE)
      raise NotImplementedError.new("#local_normal_at must be implemented by subsclasses of Shape")
    end

    def ==(other)
      transform == other.transform && material == other.material
    end
  end
end
