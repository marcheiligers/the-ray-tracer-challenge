require "./requires"

module Chapter1
  VERSION = "0.1.0"

  alias TUPLE = RayTracer::Tuple::TUPLE
  extend RayTracer::Tuple

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

  def self.run
    env = Environment.new(gravity: vector(0, -0.1, 0), wind: vector(-0.01, 0, 0))
    proj = Projectile.new(position: point(0, 1, 0), velocity: normalize(vector(1, 1, 0)))
    while proj.position.y >= 0
      proj = tick(env, proj)
      puts proj.position
    end
  end
end

Chapter1.run

# window = Window.new
# window.primitives << Line.new(x1: 10, y1: 10, x2: 100, y2: 100)
# window.event_loop
