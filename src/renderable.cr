class Renderable
  property :r, :g, :b, :a

  @r : UInt8
  @g : UInt8
  @b : UInt8
  @a : UInt8

  def initialize(@r = 0, @g = 0, @b = 0, @a = 255)
  end

  def render(renderer)
    LibSDL.set_render_draw_color(renderer, @r, @g, @b, @a)
  end
end
