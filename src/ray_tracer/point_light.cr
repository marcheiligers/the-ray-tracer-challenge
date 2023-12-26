module RayTracer
  class PointLight
    include Tuple
    extend Tuple
    include Color
    extend Color

    getter :position, :intensity

    NIL = PointLight.new(point(0, 0, 0), color(0, 0, 0))

    def initialize(@position : TUPLE, @intensity : COLOR)
      raise "Origin must be a point not #{@position}" unless point?(@position)
    end

    def ==(other)
      position == other.position && intensity == other.intensity
    end
  end
end
