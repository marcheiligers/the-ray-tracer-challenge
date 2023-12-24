module RayTracer
  class Sphere
    @transform : Matrix
    @inverse_transform : Matrix

    getter :transform, :inverse_transform

    def initialize
      @transform = Matrix::IDENTITY_4
      @inverse_transform = Matrix::IDENTITY_4
    end

    def transform=(val : Matrix)
      @transform = val
      @inverse_transform = val.inverse
    end
  end
end
