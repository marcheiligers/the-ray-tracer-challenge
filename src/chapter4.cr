require "./requires"

module Chapter4
  VERSION = "0.1.0"

  alias TUPLE = RayTracer::Tuple::TUPLE
  include RayTracer
  extend RayTracer::Tuple
  extend RayTracer::Color

  def self.draw(canvas, x, y)
    loc_x = x + 240
    loc_y = y + 240
    canvas.write_pixel(loc_x, loc_y, Color::WHITE)
    canvas.write_pixel(loc_x + 1, loc_y, Color::WHITE)
    canvas.write_pixel(loc_x, loc_y + 1, Color::WHITE)
    canvas.write_pixel(loc_x + 1, loc_y + 1, Color::WHITE)
    canvas.write_pixel(loc_x - 1, loc_y + 1, Color::WHITE)
    canvas.write_pixel(loc_x - 1, loc_y, Color::WHITE)
    canvas.write_pixel(loc_x, loc_y - 1, Color::WHITE)
    canvas.write_pixel(loc_x - 1, loc_y - 1, Color::WHITE)
    canvas.write_pixel(loc_x + 1, loc_y - 1, Color::WHITE)
  end

  def self.run
    canvas = Canvas.new(480, 480)
    rota = Math::PI / 6
    p = point(0, 220, 0)
    t = Matrix.rotation_z(rota)
    12.times do
      draw(canvas, p.x, p.y)
      p = t * p
    end

    File.write("chapter4.ppm", canvas.to_ppm)
  end
end

Chapter4.run

# window = Window.new
# window.primitives << Line.new(x1: 10, y1: 10, x2: 100, y2: 100)
# window.event_loop
