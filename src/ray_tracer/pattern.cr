module RayTracer
  class Pattern
    include Color
    include Tuple

    getter(transform : Matrix)
    getter(inverse_transform : Matrix)
    getter(transpose_inverse_transform : Matrix)

    def initialize(@transform = Matrix::IDENTITY_4)
      @inverse_transform = @transform.inverse
      @transpose_inverse_transform = @inverse_transform.transpose
    end

    def transform=(val : Matrix)
      @transform = val
      @inverse_transform = val.inverse
      @transpose_inverse_transform = @inverse_transform.transpose
    end

    def pattern_at(point : TUPLE)
      raise NotImplementedError.new("#pattern_at must be implemented by subsclasses of Pattern")
    end

    def pattern_at_shape(object : Shape, world_point : TUPLE)
      object_point = object.inverse_transform * world_point
      pattern_point = inverse_transform * object_point
      pattern_at(pattern_point)
    end

    def ==(other : Pattern)
      false
    end

    def dup
      raise NotImplementedError.new("#dup must be implemented by subsclasses of Pattern")
    end
  end
end
