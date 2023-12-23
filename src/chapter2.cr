require "./requires"

module Chapter2
  VERSION = "0.1.0"

  alias TUPLE = RayTracer::Tuple::TUPLE
  include RayTracer
  extend RayTracer::Tuple
  extend RayTracer::Color

  class Projectile
    getter :position, :velocity

    def initialize(position : TUPLE, velocity : TUPLE)
      raise "Position must be a point" unless position.point?
      raise "Velocity must be a vector" unless velocity.vector?

      @position = position
      @velocity = velocity
    end
  end

  class Environment
    getter :gravity, :wind

    def initialize(gravity : TUPLE, wind : TUPLE)
      raise "Garvity must be a vector" unless gravity.vector?
      raise "Wind must be a vector" unless wind.vector?

      @gravity = gravity
      @wind = wind
    end
  end

  def self.tick(env, proj)
    position = proj.position + proj.velocity
    velocity = proj.velocity + env.gravity + env.wind
    Projectile.new(position, velocity)
  end

  WIDTH    = 640_u32
  HEIGHT   = 480_u32
  OFFSET_Y =  20_u32

  def self.run
    canvas = Canvas.new(640, 480)
    green = color(0, 200, 0)
    WIDTH.times { |i| canvas.write_pixel(i, HEIGHT - OFFSET_Y, green) }
    env = Environment.new(gravity: vector(0, -0.1, 0), wind: vector(-0.01, 0, 0))
    # proj = Projectile.new(position: point(0, 1, 0), velocity: normalize(vector(1, 1, 0)))
    proj = Projectile.new(position: point(0, 1, 0), velocity: vector(4.5, 8, 0))
    i = 0
    while proj.position.y >= 0
      canvas.write_pixel(proj.position.x.round.to_u32, (HEIGHT - proj.position.y.round.to_u32) - OFFSET_Y, Color::WHITE)
      proj = tick(env, proj)
    end

    File.write("chapter2.ppm", canvas.to_ppm)
  end
end

Chapter2.run

# window = Window.new
# window.primitives << Line.new(x1: 10, y1: 10, x2: 100, y2: 100)
# window.event_loop
