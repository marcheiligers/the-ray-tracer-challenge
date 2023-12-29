require "./requires"

module Chapter7
  VERSION = "0.1.0"

  alias TUPLE = RayTracer::Tuple::TUPLE
  include RayTracer
  extend RayTracer::Tuple
  extend RayTracer::Color

  def self.run
    floor = Sphere.new
    floor.transform = Matrix.scaling(10, 0.01, 10)
    floor.material = Material.new
    floor.material.color = color(1, 0.9, 0.9)
    floor.material.specular = 0

    left_wall = Sphere.new
    left_wall.transform = Matrix.translation(0, 0, 5) * Matrix.rotation_y(-Math::PI/4) * Matrix.rotation_x(Math::PI/2) * Matrix.scaling(10, 0.1, 10)
    left_wall.material = floor.material

    right_wall = Sphere.new
    right_wall.transform = Matrix.translation(0, 0, 5) * Matrix.rotation_y(Math::PI/4) * Matrix.rotation_x(Math::PI/2) * Matrix.scaling(10, 0.1, 10)
    right_wall.material = floor.material

    middle = Sphere.new
    middle.transform = Matrix.translation(-0.5, 1, 0.5)
    middle.material = Material.new
    middle.material.color = color(0xDF / 255_f32, 0x14 / 255_f32, 0x8A / 255_f32) # #DF148A #060105
    middle.material.diffuse = 0.7
    middle.material.specular = 0.3

    right = Sphere.new
    right.transform = Matrix.translation(1.5, 0.5, -0.5) * Matrix.scaling(0.5, 0.5, 0.5)
    right.material = Material.new
    right.material.color = color(0x06 / 255_f32, 0x01 / 255_f32, 0x05 / 255_f32)
    right.material.diffuse = 1.0
    right.material.specular = 1.0
    right.material.shininess = 500.0_f32

    left = Sphere.new
    left.transform = Matrix.translation(-1.5, 0.33, -0.75) * Matrix.scaling(0.33, 0.33, 0.33)
    left.material = Material.new
    left.material.color = color(0x06 / 255_f32, 0x01 / 255_f32, 0x05 / 255_f32)
    left.material.diffuse = 10.0
    left.material.specular = 1.0
    left.material.shininess = 500.0_f32

    world = World.new
    world.objects.push(floor, left_wall, right_wall, middle, right, left)
    world.light = PointLight.new(point(-10, 10, -10), color(1, 1, 1))

    # camera = Camera.new(1280, 720, Math::PI/3, Matrix.view_transform(point(0, 1.5, -5), point(0, 1, 0), vector(0, 1, 0)))
    camera = Camera.new(640, 480, Math::PI/3, Matrix.view_transform(point(0, 1.5, -5), point(0, 1, 0), vector(0, 1, 0)))
    canvas = camera.render(world)

    File.write("chapter7.ppm", canvas.to_ppm)
  end
end

Chapter7.run

# window = Window.new
# window.primitives << Line.new(x1: 10, y1: 10, x2: 100, y2: 100)
# window.event_loop
