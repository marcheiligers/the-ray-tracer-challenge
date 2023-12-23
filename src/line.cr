class Line < Renderable
  @r : UInt8
  @g : UInt8
  @b : UInt8
  @a : UInt8

  def initialize(@x1 = 0.0, @y1 = 0.0, @x2 = 0.0, @y2 = 0.0, @r = 0_u8, @g = 0_u8, @b = 0_u8, @a = 255_u8)
  end

  def render(renderer)
    super(renderer)
    LibSDL.render_draw_line_f(renderer, @x1, @y1, @x2, @y2)
  end
end
