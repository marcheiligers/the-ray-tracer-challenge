require "./spec_helper"

describe RayTracer::Material do
  # Scenario: The default material
  #   Given m ← material()
  #   Then m.color = color(1, 1, 1)
  #     And m.ambient = 0.1
  #     And m.diffuse = 0.9
  #     And m.specular = 0.9
  #     And m.shininess = 200.0
  it "the default material" do
    m = RayTracer::Material.new
    m.pattern.should eq(RayTracer::SolidPattern.new(RayTracer::Color.color(1, 1, 1)))
    m.ambient.should eq(0.1_f32)
    m.diffuse.should eq(0.9_f32)
    m.specular.should eq(0.9_f32)
    m.shininess.should eq(200.0_f32)
  end

  # Background:
  #   Given m ← material()
  #     And position ← point(0, 0, 0)

  # Scenario: Lighting with the eye between the light and the surface
  #  Given eyev ← vector(0, 0, -1)
  #    And normalv ← vector(0, 0, -1)
  #    And light ← point_light(point(0, 0, -10), color(1, 1, 1))
  #  When result ← lighting(m, light, position, eyev, normalv)
  #  Then result = color(1.9, 1.9, 1.9)
  it "lighting with the eye between the light and the surface" do
    # background
    m = RayTracer::Material.new
    position = RayTracer::Tuple.point(0, 0, 0)

    eyev = RayTracer::Tuple.vector(0, 0, -1)
    normalv = RayTracer::Tuple.vector(0, 0, -1)
    light = RayTracer::PointLight.new(RayTracer::Tuple.point(0, 0, -10), RayTracer::Color.color(1, 1, 1))
    result = m.lighting(RayTracer::Sphere.new, light, position, eyev, normalv)
    result.should eq(RayTracer::Color.color(1.9, 1.9, 1.9))
  end

  # Scenario: Lighting with the eye between light and surface, eye offset 45°
  #   Given eyev ← vector(0, √2/2, -√2/2)
  #     And normalv ← vector(0, 0, -1)
  #     And light ← point_light(point(0, 0, -10), color(1, 1, 1))
  #   When result ← lighting(m, light, position, eyev, normalv)
  #   Then result = color(1.0, 1.0, 1.0)
  it "lighting with the eye between light and surface, eye offset 45°" do
    # background
    m = RayTracer::Material.new
    position = RayTracer::Tuple.point(0, 0, 0)

    sq2 = Math.sqrt(2) / 2
    eyev = RayTracer::Tuple.vector(0, sq2, -sq2)
    normalv = RayTracer::Tuple.vector(0, 0, -1)
    light = RayTracer::PointLight.new(RayTracer::Tuple.point(0, 0, -10), RayTracer::Color.color(1, 1, 1))
    result = m.lighting(RayTracer::Sphere.new, light, position, eyev, normalv)
    result.should eq(RayTracer::Color.color(1.0, 1.0, 1.0))
  end

  # Scenario: Lighting with eye opposite surface, light offset 45°
  #   Given eyev ← vector(0, 0, -1)
  #     And normalv ← vector(0, 0, -1)
  #     And light ← point_light(point(0, 10, -10), color(1, 1, 1))
  #   When result ← lighting(m, light, position, eyev, normalv)
  #   Then result = color(0.7364, 0.7364, 0.7364)
  it "lighting with eye opposite surface, light offset 45°" do
    # background
    m = RayTracer::Material.new
    position = RayTracer::Tuple.point(0, 0, 0)

    eyev = RayTracer::Tuple.vector(0, 0, -1)
    normalv = RayTracer::Tuple.vector(0, 0, -1)
    light = RayTracer::PointLight.new(RayTracer::Tuple.point(0, 10, -10), RayTracer::Color.color(1, 1, 1))
    result = m.lighting(RayTracer::Sphere.new, light, position, eyev, normalv)
    result.should be_close(RayTracer::Color.color(0.7364, 0.7364, 0.7364), RayTracer::EPSILON)
  end

  # Scenario: Lighting with eye in the path of the reflection vector
  #   Given eyev ← vector(0, -√2/2, -√2/2)
  #     And normalv ← vector(0, 0, -1)
  #     And light ← point_light(point(0, 10, -10), color(1, 1, 1))
  #   When result ← lighting(m, light, position, eyev, normalv)
  #   Then result = color(1.6364, 1.6364, 1.6364)
  it "lighting with eye in the path of the reflection vector" do
    # background
    m = RayTracer::Material.new
    position = RayTracer::Tuple.point(0, 0, 0)

    sq2 = Math.sqrt(2) / 2
    eyev = RayTracer::Tuple.vector(0, -sq2, -sq2)
    normalv = RayTracer::Tuple.vector(0, 0, -1)
    light = RayTracer::PointLight.new(RayTracer::Tuple.point(0, 10, -10), RayTracer::Color.color(1, 1, 1))
    result = m.lighting(RayTracer::Sphere.new, light, position, eyev, normalv)
    result.should be_close(RayTracer::Color.color(1.6364, 1.6364, 1.6364), RayTracer::EPSILON)
  end

  # Scenario: Lighting with the light behind the surface
  #   Given eyev ← vector(0, 0, -1)
  #     And normalv ← vector(0, 0, -1)
  #     And light ← point_light(point(0, 0, 10), color(1, 1, 1))
  #   When result ← lighting(m, light, position, eyev, normalv)
  #   Then result = color(0.1, 0.1, 0.1)
  it "lighting with the light behind the surface" do
    # background
    m = RayTracer::Material.new
    position = RayTracer::Tuple.point(0, 0, 0)

    eyev = RayTracer::Tuple.vector(0, 0, -1)
    normalv = RayTracer::Tuple.vector(0, 0, -1)
    light = RayTracer::PointLight.new(RayTracer::Tuple.point(0, 0, 10), RayTracer::Color.color(1, 1, 1))
    result = m.lighting(RayTracer::Sphere.new, light, position, eyev, normalv)
    result.should eq(RayTracer::Color.color(0.1, 0.1, 0.1))
  end

  # Scenario: Lighting with the surface in shadow
  #   Given eyev ← vector(0, 0, -1)
  #     And normalv ← vector(0, 0, -1)
  #     And light ← point_light(point(0, 0, -10), color(1, 1, 1))
  #     And in_shadow ← true
  #   When result ← lighting(m, light, position, eyev, normalv, in_shadow)
  #   Then result = color(0.1, 0.1, 0.1)
  it "lighting with the surface in shadow" do
    # background
    m = RayTracer::Material.new
    position = RayTracer::Tuple.point(0, 0, 0)

    eyev = RayTracer::Tuple.vector(0, 0, -1)
    normalv = RayTracer::Tuple.vector(0, 0, -1)
    light = RayTracer::PointLight.new(RayTracer::Tuple.point(0, 0, -10), RayTracer::Color.color(1, 1, 1))
    in_shadow = true

    result = m.lighting(RayTracer::Sphere.new, light, position, eyev, normalv, in_shadow)
    result.should eq(RayTracer::Color.color(0.1, 0.1, 0.1))
  end

  # Scenario: Lighting with a pattern applied
  #   Given m.pattern ← stripe_pattern(color(1, 1, 1), color(0, 0, 0))
  #     And m.ambient ← 1
  #     And m.diffuse ← 0
  #     And m.specular ← 0
  #     And eyev ← vector(0, 0, -1)
  #     And normalv ← vector(0, 0, -1)
  #     And light ← point_light(point(0, 0, -10), color(1, 1, 1))
  #   When c1 ← lighting(m, light, point(0.9, 0, 0), eyev, normalv, false)
  #     And c2 ← lighting(m, light, point(1.1, 0, 0), eyev, normalv, false)
  #   Then c1 = color(1, 1, 1)
  #     And c2 = color(0, 0, 0)
  it "lighting with the surface in shadow" do
    m = RayTracer::Material.new
    m.pattern = RayTracer::StripePattern.new(RayTracer::Color::WHITE, RayTracer::Color::BLACK)
    m.ambient = 1_f32
    m.diffuse = 0_f32
    m.specular = 0_f32

    eyev = RayTracer::Tuple.vector(0, 0, -1)
    normalv = RayTracer::Tuple.vector(0, 0, -1)
    light = RayTracer::PointLight.new(RayTracer::Tuple.point(0, 0, -10), RayTracer::Color.color(1, 1, 1))

    c1 = m.lighting(RayTracer::Sphere.new, light, RayTracer::Tuple.point(0.9, 0, 0), eyev, normalv, false)
    c2 = m.lighting(RayTracer::Sphere.new, light, RayTracer::Tuple.point(1.1, 0, 0), eyev, normalv, false)

    c1.should eq(RayTracer::Color::WHITE)
    c2.should eq(RayTracer::Color::BLACK)
  end
end
