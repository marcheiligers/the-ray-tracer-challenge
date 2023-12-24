module RayTracer
  class Canvas
    getter :width, :height

    def initialize(@width : UInt32, @height : UInt32, @bg : Color::COLOR = Color::BLACK)
      @pixels = Array(Array(Color::COLOR)).new(@height) do
        Array(Color::COLOR).new(@width, @bg)
      end
    end

    def pixel_at(x, y)
      @pixels[y][x]
    end

    def write_pixel(x, y, color : Color::COLOR)
      @pixels[y][x] = color
    end

    def write_pixel(x : Float64, y : Float64, color : Color::COLOR)
      @pixels[y.round.to_i32][x.round.to_i32] = color
    end

    private def to_255(value) : Int32
      val = (value * 255).round.to_i32
      val = 0_i32 if val < 0
      val = 255_i32 if val > 255
      val
    end

    def to_ppm
      ppm = String::Builder.new("P3\n#{@width} #{@height}\n255\n")
      @pixels.each do |line|
        cur_line = ""
        line.each do |pixel|
          pixel.values.each do |col|
            val = "#{cur_line == "" ? "" : " "}#{to_255(col)}"
            if cur_line.size + val.size > 70
              ppm.puts cur_line
              cur_line = val.strip
            else
              cur_line += val
            end
          end
        end
        ppm.puts cur_line
      end
      ppm.to_s
    end
  end
end
