module RayTracer
  class PointLight
    include Tuple
    include Color

    getter :position, :intensity

    def initialize(@position : TUPLE, @intensity : COLOR)
      raise "Origin must be a point not #{@position}" unless point?(@position)
    end
  end
end
