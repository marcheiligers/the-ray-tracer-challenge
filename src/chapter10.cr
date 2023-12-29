require "./requires"

module Chapter10
  VERSION = "0.1.0"

  include RayTracer
  extend RayTracer::Tuple
  extend RayTracer::Color

  def self.run
    π = Math::PI

    floor = Plane.new(
      material: Material.new(
        specular: 1.0_f32,
        pattern: BlendedPattern.new(
          CheckersPattern.new(
            0xFFFFFF,
            0xFF00FF,
            Matrix.rotation_y(π/4)
          ),
          CheckersPattern.new(
            0x1F7621,
            0xB7F5D0,
            Matrix.translation(0, 0.5, 0).scaling(0.5, 0.5, 0.5)
          )
        )
      )
    )

    left_wall = Plane.new(
      Matrix.translation(0, 0, 5).rotation_y(-π/4).rotation_x(π/2),
      Material.new(
        pattern: RingPattern.new(color(0x1F7621), color(0xB7F5D0))
      )
    )

    right_wall = Plane.new(
      Matrix.translation(0, 0, 5).rotation_y(π/4).rotation_x(π/2),
      Material.new(
        pattern: GradientPattern.new(
          0x1F7621,
          0x3F9641,
          Matrix.rotation_y(π/4)
        )
      )
    )

    middle = Sphere.new
    middle.transform = Matrix.translation(-0.5, 1, 0.5)
    middle.material = Material.new
    middle.material.diffuse = 0.7
    middle.material.specular = 0.3
    middle.material.pattern = StripePattern.new(color(0x9C518A), color(0xFCF744))
    middle.material.pattern.transform = Matrix.scaling(0.2, 0.2, 0.2).rotation_z(π/8).rotation_x(π/8)

    right = Sphere.new(
      Matrix.translation(1.5, 0.5, -0.5).scaling(0.5, 0.5, 0.5),
      Material.new(
        diffuse: 0.7_f32,
        specular: 0.3_f32,
        pattern: CheckersPattern.new(
          0xEDF4AA,
          0x48558A,
          Matrix.scaling(0.4, 0.4, 0.4).rotation_z(π/8).rotation_x(π/8)
        )
      )
    )

    left = Sphere.new(
      Matrix.translation(-1.5, 0.33, -0.75).scaling(0.33, 0.33, 0.33),
      Material.new(
        pattern: CheckersPattern.new(
          StripePattern.new(color(0xEDF4AA), color(0x48558A)),
          StripePattern.new(color(0x9E7651), color(0x160905)),
          Matrix.scaling(0.4, 0.4, 0.4).rotation_z(π/3).rotation_y(π/3)
        ),
        diffuse: 0.7_f32,
        specular: 0.3_f32
      )
    )

    world = World.new
    world.objects.push(floor, left_wall, right_wall, middle, right, left)
    world.light = PointLight.new(point(-10, 10, -10), color(1, 1, 1))

    camera = Camera.new(1280, 720, π/3, Matrix.view_transform(point(0, 1.5, -5), point(0, 1, 0), vector(0, 1, 0)))
    # camera = Camera.new(640, 480, π/3, Matrix.view_transform(point(0, 1.5, -5), point(0, 1, 0), vector(0, 1, 0)))
    # camera = Camera.new(160, 120, π/3, Matrix.view_transform(point(0, 1.5, -5), point(0, 1, 0), vector(0, 1, 0)))
    canvas = camera.render(world, true)

    File.write("chapter10_nice.ppm", canvas.to_ppm)
  end
end

Chapter10.run

# window = Window.new
# window.primitives << Line.new(x1: 10, y1: 10, x2: 100, y2: 100)
# window.event_loop
