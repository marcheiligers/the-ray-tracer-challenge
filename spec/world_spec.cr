require "./spec_helper"

describe RayTracer::World do
  # Scenario: Creating a world
  #   Given w ← world()
  #   Then w contains no objects
  #     And w has no light source
  it "creating a world" do
    s = RayTracer::World.new
    s.objects.should be_empty
    s.light.should eq(RayTracer::PointLight::NIL)
  end

  # Scenario: The default world
  #   Given light ← point_light(point(-10, 10, -10), color(1, 1, 1))
  #     And s1 ← sphere() with:
  #       | material.color     | (0.8, 1.0, 0.6)        |
  #       | material.diffuse   | 0.7                    |
  #       | material.specular  | 0.2                    |
  #     And s2 ← sphere() with:
  #       | transform | scaling(0.5, 0.5, 0.5) |
  #   When w ← default_world()
  #   Then w.light = light
  #     And w contains s1
  #     And w contains s2
  it "the default world" do
    light = RayTracer::PointLight.new(RayTracer::Tuple.point(-10, 10, -10), RayTracer::Color.color(1, 1, 1))

    material = RayTracer::Material.new
    material.pattern = RayTracer::SolidPattern.new(RayTracer::Color.color(0.8, 1.0, 0.6))
    material.diffuse = 0.7
    material.specular = 0.2
    s1 = RayTracer::Sphere.new
    s1.material = material

    transform = RayTracer::Matrix.scaling(0.5, 0.5, 0.5)
    s2 = RayTracer::Sphere.new
    s2.transform = transform

    w = RayTracer::World.default
    w.light.should eq(light)
    w.objects.should contain(s1)
    w.objects.should contain(s2)
  end

  # Scenario: Intersect a world with a ray
  #   Given w ← default_world()
  #     And r ← ray(point(0, 0, -5), vector(0, 0, 1))
  #   When xs ← intersect_world(w, r)
  #   Then xs.count = 4
  #     And xs[0].t = 4
  #     And xs[1].t = 4.5
  #     And xs[2].t = 5.5
  #     And xs[3].t = 6
  it "the default world" do
    w = RayTracer::World.default
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, -5), RayTracer::Tuple.vector(0, 0, 1))
    xs = w.intersects(r)
    xs[0].t.should eq(4)
    xs[1].t.should eq(4.5)
    xs[2].t.should eq(5.5)
    xs[3].t.should eq(6)
  end

  # Scenario: Shading an intersection
  #   Given w ← default_world()
  #     And r ← ray(point(0, 0, -5), vector(0, 0, 1))
  #     And shape ← the first object in w
  #     And i ← intersection(4, shape)
  #   When comps ← prepare_computations(i, r)
  #     And c ← shade_hit(w, comps)
  #   Then c = color(0.38066, 0.47583, 0.2855)
  it "shading an intersection" do
    w = RayTracer::World.default
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, -5), RayTracer::Tuple.vector(0, 0, 1))
    shape = w.objects.first
    i = RayTracer::Intersection.new(4, shape)
    comps = RayTracer::Computation.new(i, r)
    c = w.shade_hit(comps)
    c.should be_close(RayTracer::Color.color(0.38066, 0.47583, 0.2855), RayTracer::EPSILON)
  end

  # Scenario: Shading an intersection from the inside
  #   Given w ← default_world()
  #     And w.light ← point_light(point(0, 0.25, 0), color(1, 1, 1))
  #     And r ← ray(point(0, 0, 0), vector(0, 0, 1))
  #     And shape ← the second object in w
  #     And i ← intersection(0.5, shape)
  #   When comps ← prepare_computations(i, r)
  #     And c ← shade_hit(w, comps)
  #   Then c = color(0.90498, 0.90498, 0.90498)
  it "shading an intersection from the inside" do
    w = RayTracer::World.default
    w.light = RayTracer::PointLight.new(RayTracer::Tuple.point(0, 0.25, 0), RayTracer::Color.color(1, 1, 1))
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, 0), RayTracer::Tuple.vector(0, 0, 1))
    shape = w.objects[1]
    i = RayTracer::Intersection.new(0.5, shape)

    comps = RayTracer::Computation.new(i, r)
    c = w.shade_hit(comps)
    c.should be_close(RayTracer::Color.color(0.90498, 0.90498, 0.90498), RayTracer::EPSILON)
  end

  # Scenario: The color when a ray misses
  #   Given w ← default_world()
  #     And r ← ray(point(0, 0, -5), vector(0, 1, 0))
  #   When c ← color_at(w, r)
  #   Then c = color(0, 0, 0)
  it "shading an intersection from the inside" do
    w = RayTracer::World.default
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, -5), RayTracer::Tuple.vector(0, 1, 0))
    c = w.color_at(r)
    c.should eq(RayTracer::Color::BLACK)
  end

  # Scenario: The color when a ray hits
  #   Given w ← default_world()
  #     And r ← ray(point(0, 0, -5), vector(0, 0, 1))
  #   When c ← color_at(w, r)
  #   Then c = color(0.38066, 0.47583, 0.2855)
  it "shading an intersection from the inside" do
    w = RayTracer::World.default
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, -5), RayTracer::Tuple.vector(0, 0, 1))
    c = w.color_at(r)
    c.should be_close(RayTracer::Color.color(0.38066, 0.47583, 0.2855), RayTracer::EPSILON)
  end

  # Scenario: The color with an intersection behind the ray
  #   Given w ← default_world()
  #     And outer ← the first object in w
  #     And outer.material.ambient ← 1
  #     And inner ← the second object in w
  #     And inner.material.ambient ← 1
  #     And r ← ray(point(0, 0, 0.75), vector(0, 0, -1))
  #   When c ← color_at(w, r)
  #   Then c = inner.material.color
  it "shading an intersection from the inside" do
    w = RayTracer::World.default
    outer = w.objects[0]
    outer.material.ambient = 1
    inner = w.objects[1]
    inner.material.ambient = 1
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, 0.75), RayTracer::Tuple.vector(0, 0, -1))
    c = w.color_at(r)
    c.should eq(inner.material.pattern.as(RayTracer::SolidPattern).color)
  end

  # Scenario: There is no shadow when nothing is collinear with point and light
  #   Given w ← default_world()
  #     And p ← point(0, 10, 0)
  #    Then is_shadowed(w, p) is false
  it "there is no shadow when nothing is collinear with point and light" do
    w = RayTracer::World.default
    p = RayTracer::Tuple.point(0, 10, 0)
    w.shadowed?(p).should be_false
  end

  # Scenario: The shadow when an object is between the point and the light
  #   Given w ← default_world()
  #     And p ← point(10, -10, 10)
  #    Then is_shadowed(w, p) is true
  it "the shadow when an object is between the point and the light" do
    w = RayTracer::World.default
    p = RayTracer::Tuple.point(10, -10, 10)
    w.shadowed?(p).should be_true
  end

  # Scenario: There is no shadow when an object is behind the light
  #   Given w ← default_world()
  #     And p ← point(-20, 20, -20)
  #    Then is_shadowed(w, p) is false
  it "there is no shadow when an object is behind the light" do
    w = RayTracer::World.default
    p = RayTracer::Tuple.point(-20, 20, -20)
    w.shadowed?(p).should be_false
  end

  # Scenario: There is no shadow when an object is behind the point
  #   Given w ← default_world()
  #     And p ← point(-2, 2, -2)
  #    Then is_shadowed(w, p) is false
  it "there is no shadow when an object is behind the point" do
    w = RayTracer::World.default
    p = RayTracer::Tuple.point(-2, 2, -2)
    w.shadowed?(p).should be_false
  end

  # Scenario: shade_hit() is given an intersection in shadow
  #   Given w ← world()
  #     And w.light ← point_light(point(0, 0, -10), color(1, 1, 1))
  #     And s1 ← sphere()
  #     And s1 is added to w
  #     And s2 ← sphere() with:
  #       | transform | translation(0, 0, 10) |
  #     And s2 is added to w
  #     And r ← ray(point(0, 0, 5), vector(0, 0, 1))
  #     And i ← intersection(4, s2)
  #   When comps ← prepare_computations(i, r)
  #     And c ← shade_hit(w, comps)
  #   Then c = color(0.1, 0.1, 0.1)
  it "shade_hit() is given an intersection in shadow" do
    w = RayTracer::World.new
    w.light = RayTracer::PointLight.new(RayTracer::Tuple.point(0, 0, -10), RayTracer::Color.color(1, 1, 1))
    s1 = RayTracer::Sphere.new
    w.objects << s1

    transform = RayTracer::Matrix.translation(0, 0, 10)
    s2 = RayTracer::Sphere.new
    s2.transform = transform
    w.objects << s2

    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, 5), RayTracer::Tuple.vector(0, 0, 1))
    i = RayTracer::Intersection.new(4, s2)

    comps = RayTracer::Computation.new(i, r)
    c = w.shade_hit(comps)
    c.should eq(RayTracer::Color.color(0.1, 0.1, 0.1))
  end
end
