module RayTracer
  class Camera
    include Tuple
    extend Tuple

    getter(hsize : UInt32)
    getter(vsize : UInt32)
    getter(field_of_view : Float64)
    getter(transform : Matrix)
    getter(pixel_size : Float64)

    @half_width : Float64
    @half_height : Float64
    @inverse_transform : Matrix

    def initialize(@hsize : UInt32, @vsize : UInt32, @field_of_view : Float64, @transform : Matrix = Matrix::IDENTITY_4)
      half_view = Math.tan(field_of_view / 2)
      aspect = hsize.to_f64 / vsize.to_f64
      if aspect >= 1
        @half_width = half_view
        @half_height = half_view / aspect
      else
        @half_width = half_view * aspect
        @half_height = half_view
      end
      @pixel_size = (@half_width * 2) / @hsize
      @inverse_transform = transform.inverse
    end

    def ray_for_pixel(px, py)
      # the offset from the edge of the canvas to the pixel's center
      xoffset = (px + 0.5) * pixel_size
      yoffset = (py + 0.5) * pixel_size
      # the untransformed coordinates of the pixel in world space.
      # (remember that the camera looks toward -z, so +x is to the *left*.)
      world_x = @half_width - xoffset
      world_y = @half_height - yoffset
      # using the camera matrix, transform the canvas point and the origin,
      # and then compute the ray's direction vector.
      # (remember that the canvas is at z=-1)
      pixel = @inverse_transform * point(world_x, world_y, -1)
      origin = @inverse_transform * ORIGIN
      direction = normalize(pixel - origin)
      Ray.new(origin, direction)
    end

    def render(world : World)
      image = Canvas.new(hsize, vsize)
      vsize.times do |y|
        hsize.times do |x|
          ray = ray_for_pixel(x, y)
          color = world.color_at(ray)
          image.write_pixel(x, y, color)
        end
      end
      image
    end
  end
end
