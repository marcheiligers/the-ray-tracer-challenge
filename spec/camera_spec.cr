require "./spec_helper"

describe RayTracer::Camera do
  # Scenario: Constructing a camera
  #   Given hsize ← 160
  #     And vsize ← 120
  #     And field_of_view ← π/2
  #   When c ← camera(hsize, vsize, field_of_view)
  #   Then c.hsize = 160
  #     And c.vsize = 120
  #     And c.field_of_view = π/2
  #     And c.transform = identity_matrix
  it "constructing a camera" do
    hsize = 160_u32
    vsize = 120_u32
    field_of_view = Math::PI/2
    c = RayTracer::Camera.new(hsize, vsize, field_of_view)
    c.hsize.should eq(160_u32)
    c.vsize.should eq(120_u32)
    c.field_of_view.should eq(Math::PI/2)
    c.transform.should eq(RayTracer::Matrix::IDENTITY_4)
  end

  # Scenario: The pixel size for a horizontal canvas
  #   Given c ← camera(200, 125, π/2)
  #   Then c.pixel_size = 0.01
  it "the pixel size for a horizontal canvas" do
    c = RayTracer::Camera.new(200_u32, 125_u32, Math::PI/2)
    c.pixel_size.should be_close(0.01, RayTracer::EPSILON)
  end

  # Scenario: The pixel size for a vertical canvas
  #   Given c ← camera(125, 200, π/2)
  #   Then c.pixel_size = 0.01
  it "the pixel size for a vertical canvas" do
    c = RayTracer::Camera.new(125_u32, 200_u32, Math::PI/2)
    c.pixel_size.should be_close(0.01, RayTracer::EPSILON)
  end

  # Scenario: Constructing a ray through the center of the canvas
  #   Given c ← camera(201, 101, π/2)
  #   When r ← ray_for_pixel(c, 100, 50)
  #   Then r.origin = point(0, 0, 0)
  #     And r.direction = vector(0, 0, -1)
  it "constructing a ray through the center of the canvas" do
    c = RayTracer::Camera.new(201_u32, 101_u32, Math::PI/2)
    r = c.ray_for_pixel(100_u32, 50_u32)
    r.origin.should eq(RayTracer::Tuple.point(0, 0, 0))
    r.direction.should be_close(RayTracer::Tuple.vector(0, 0, -1), RayTracer::EPSILON)
  end

  # Scenario: Constructing a ray through a corner of the canvas
  #   Given c ← camera(201, 101, π/2)
  #   When r ← ray_for_pixel(c, 0, 0)
  #   Then r.origin = point(0, 0, 0)
  #     And r.direction = vector(0.66519, 0.33259, -0.66851)
  it "constructing a ray through a corner of the canvas" do
    c = RayTracer::Camera.new(201_u32, 101_u32, Math::PI/2)
    r = c.ray_for_pixel(0_u32, 0_u32)
    r.origin.should eq(RayTracer::Tuple.point(0, 0, 0))
    r.direction.should be_close(RayTracer::Tuple.vector(0.66519, 0.33259, -0.66851), RayTracer::EPSILON)
  end

  # Scenario: Constructing a ray when the camera is transformed
  #   Given c ← camera(201, 101, π/2)
  #   When c.transform ← rotation_y(π/4) * translation(0, -2, 5)
  #     And r ← ray_for_pixel(c, 100, 50)
  #   Then r.origin = point(0, 2, -5)
  #     And r.direction = vector(√2/2, 0, -√2/2)
  it "constructing a ray when the camera is transformed" do
    c = RayTracer::Camera.new(201_u32, 101_u32, Math::PI/2, RayTracer::Matrix.rotation_y(Math::PI/4) * RayTracer::Matrix.translation(0, -2, 5))
    r = c.ray_for_pixel(100_u32, 50_u32)
    r.origin.should eq(RayTracer::Tuple.point(0, 2, -5))
    sq2 = Math.sqrt(2) / 2
    r.direction.should be_close(RayTracer::Tuple.vector(sq2, 0, -sq2), RayTracer::EPSILON)
  end

  # Scenario: Rendering a world with a camera
  #   Given w ← default_world()
  #     And c ← camera(11, 11, π/2)
  #     And from ← point(0, 0, -5)
  #     And to ← point(0, 0, 0)
  #     And up ← vector(0, 1, 0)
  #     And c.transform ← view_transform(from, to, up)
  #   When image ← render(c, w)
  #   Then pixel_at(image, 5, 5) = color(0.38066, 0.47583, 0.2855)
  it "rendering a world with a camera" do
    w = RayTracer::World.default
    t = RayTracer::Matrix.view_transform(RayTracer::Matrix.point(0, 0, -5), RayTracer::Matrix.point(0, 0, 0), RayTracer::Matrix.vector(0, 1, 0))
    c = RayTracer::Camera.new(11_u32, 11_u32, Math::PI/2, t)
    image = c.render(w)
    image.pixel_at(5, 5).should be_close(RayTracer::Color.color(0.38066, 0.47583, 0.2855), RayTracer::EPSILON)
  end
end
