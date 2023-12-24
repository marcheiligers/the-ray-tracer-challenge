require "./requires"

module Chapter6
  VERSION = "0.1.0"

  alias TUPLE = RayTracer::Tuple::TUPLE
  include RayTracer
  extend RayTracer::Tuple
  extend RayTracer::Color

  def self.run
    ray_origin = point(0, 0, -5)
    wall_z = 10
    wall_size = 7.0
    canvas_pixels = 480_u32
    pixel_size = wall_size / canvas_pixels
    half = wall_size / 2

    canvas = Canvas.new(canvas_pixels, canvas_pixels)
    shape = Sphere.new
    shape.material = Material.new
    shape.material.color = color(1, 0.2, 1)
    light_position = point(-10, 10, -10)
    light_color = color(1, 1, 1)
    light = PointLight.new(light_position, light_color)

    # shape.transform = Matrix.scaling(1, 0.5, 1) # shrink it along the y axis
    # shape.transform = Matrix.scaling(0.5, 1, 1) # shrink it along the x axis
    # shape.transform = Matrix.rotation_z(Math::PI / 4) * Matrix.scaling(0.5, 1, 1) # shrink it, and rotate it!
    shape.transform = Matrix.shearing(1, 0, 0, 0, 0, 0) * Matrix.scaling(0.5, 1, 1) # shrink it, and skew it!

    canvas_pixels.times do |y|
      world_y = half - pixel_size * y
      canvas_pixels.times do |x|
        world_x = -half + pixel_size * x
        position = point(world_x, world_y, wall_z)
        ray = Ray.new(ray_origin, normalize(position - ray_origin))
        xs = ray.intersects(shape)
        hit = xs.hit
        next unless hit

        point = ray.position(hit.t)
        normal = hit.object.normal_at(point)
        eye = -ray.direction

        color = shape.material.lighting(light, point, eye, normal)
        canvas.write_pixel(x, y, color)
      end
    end

    File.write("chapter6.ppm", canvas.to_ppm)
  end
end

Chapter6.run

# window = Window.new
# window.primitives << Line.new(x1: 10, y1: 10, x2: 100, y2: 100)
# window.event_loop
