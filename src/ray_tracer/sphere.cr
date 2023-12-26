module RayTracer
  class Sphere
    include Tuple
    @transform : Matrix
    @inverse_transform : Matrix
    @transpose_inverse_transform : Matrix

    getter :transform, :inverse_transform, :transpose_inverse_transform

    property(material) { Material.new }

    def initialize
      @transform = Matrix::IDENTITY_4
      @inverse_transform = Matrix::IDENTITY_4
      @transpose_inverse_transform = @inverse_transform.transpose
    end

    def transform=(val : Matrix)
      @transform = val
      @inverse_transform = val.inverse
      @transpose_inverse_transform = @inverse_transform.transpose
    end

    def normal_at(world_point : TUPLE)
      object_point = inverse_transform * world_point
      object_normal = object_point - ORIGIN
      world_normal = transpose_inverse_transform * object_normal
      vector(world_normal.x, world_normal.y, world_normal.z).normalize
    end

    def ==(other)
      transform == other.transform && material == other.material
    end
  end
end
