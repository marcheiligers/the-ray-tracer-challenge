module RayTracer
  module Color
    extend self

    alias COLOR = NamedTuple(r: Float32, g: Float32, b: Float32)

    BLACK = color(0, 0, 0)
    WHITE = color(255, 255, 255)

    def color(r : Float32, g : Float32, b : Float32)
      {r: r, g: g, b: b}
    end

    def add(c1 : COLOR, c2 : COLOR)
      {r: c1.r + c2.r, g: c1.g + c2.g, b: c1.b + c2.b}
    end

    def subtract(c1 : COLOR, c2 : COLOR)
      {r: c1.r - c2.r, g: c1.g - c2.g, b: c1.b - c2.b}
    end

    def multiply(c : COLOR, s : Float32)
      {r: c.r * s, g: c.g * s, b: c.b * s}
    end

    def multiply(c1 : COLOR, c2 : COLOR)
      {r: c1.r * c2.r, g: c1.g * c2.g, b: c1.b * c2.b}
    end

    def abs(c : COLOR) # magnitude, but used in be_close in tests
      Math.sqrt(c[:r] ** 2 + c[:g] ** 2 + c[:b] ** 2)
    end

    struct ::NamedTuple
      include RayTracer::Color

      def r
        raise "Don't know how to get r of #{typeof(self)}" unless typeof(self) == COLOR
        self[:r]
      end

      def g
        raise "Don't know how to get g of #{typeof(self)}" unless typeof(self) == COLOR
        self[:g]
      end

      def b
        raise "Don't know how to get b of #{typeof(self)}" unless typeof(self) == COLOR
        self[:b]
      end

      def +(other : COLOR)
        raise "Don't know how to add #{typeof(self)} and #{typeof(other)}" unless typeof(self) == COLOR
        add(self, other)
      end

      def -(other : COLOR)
        raise "Don't know how to subtract #{typeof(self)} and #{typeof(other)}" unless typeof(self) == COLOR
        subtract(self, other)
      end

      def *(scalar : Float32)
        raise "Don't know how to multiply #{typeof(self)} with a scalar" unless typeof(self) == COLOR
        multiply(self, scalar)
      end

      def *(other : COLOR)
        raise "Don't know how to multiply #{typeof(self)} and #{typeof(other)}" unless typeof(self) == COLOR
        multiply(self, other)
      end

      def abs
        raise "Don't know how to get the abs of #{typeof(self)}" unless typeof(self) == COLOR
        abs(self)
      end

      # def ==(other : COLOR)
      #   puts other
      #   (r - other.r).abs < COLOR_EPSILON && (g - other.g).abs < COLOR_EPSILON && (b - other.b).abs < COLOR_EPSILON
      # end
    end
  end
end
