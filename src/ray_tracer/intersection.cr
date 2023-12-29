module RayTracer
  class Intersection
    getter :t, :object

    def initialize(@t : Float64, @object : Shape)
    end
  end
end

module RayTracer
  class Intersections < Array(Intersection)
    def initialize(*intersections)
      super(intersections.size)
      concat(intersections)
    end

    def hit
      valid = self.select { |i| i.t >= 0 }
      return nil if valid.size == 0

      valid.sort_by { |i| i.t }.first
    end
  end
end
