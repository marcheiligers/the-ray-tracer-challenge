require "./spec_helper"

describe RayTracer::Sphere do
  # Scenario: A sphere's default transformation
  # Given s ← sphere()
  # Then s.transform = identity_matrix
  it "a sphere's default transformation" do
    s = RayTracer::Sphere.new
    s.transform.should eq(RayTracer::Matrix::IDENTITY_4)
  end

  # Scenario: Changing a sphere's transformation
  # Given s ← sphere()
  # And t ← translation(2, 3, 4)
  # When set_transform(s, t)
  # Then s.transform = t
  it "Changing a sphere's transformation" do
    s = RayTracer::Sphere.new
    t = RayTracer::Matrix.translation(2, 3, 4)
    s.transform = t
    s.transform.should eq(t)
  end

  # Scenario: A ray intersects a sphere at two points
  # Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
  # And s ← sphere()
  # When xs ← intersect(s, r)
  # Then xs.count = 2
  # And xs[0] = 4.0
  # And xs[1] = 6.0
  it "a ray intersects a sphere at two points" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, -5), RayTracer::Tuple.vector(0, 0, 1))
    s = RayTracer::Sphere.new
    xs = s.intersect(r)
    xs.size.should eq(2)
    xs[0].t.should eq(4.0)
    xs[1].t.should eq(6.0)
  end

  # Scenario: A ray intersects a sphere at a tangent
  # Given r ← ray(point(0, 1, -5), vector(0, 0, 1))
  # And s ← sphere()
  # When xs ← intersect(s, r)
  # Then xs.count = 2
  # And xs[0] = 5.0
  # And xs[1] = 5.0
  it "a ray intersects a sphere at a tangent" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 1, -5), RayTracer::Tuple.vector(0, 0, 1))
    s = RayTracer::Sphere.new
    xs = s.intersect(r)
    xs.size.should eq(2)
    xs[0].t.should eq(5.0)
    xs[1].t.should eq(5.0)
  end

  # Scenario: A ray misses a sphere
  # Given r ← ray(point(0, 2, -5), vector(0, 0, 1))
  # And s ← sphere()
  # When xs ← intersect(s, r)
  # Then xs.count = 0
  it "a ray misses a sphere" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 2, -5), RayTracer::Tuple.vector(0, 0, 1))
    s = RayTracer::Sphere.new
    xs = s.intersect(r)
    xs.size.should eq(0)
  end

  # Scenario: A ray originates inside a sphere
  # Given r ← ray(point(0, 0, 0), vector(0, 0, 1))
  # And s ← sphere()
  # When xs ← intersect(s, r)
  # Then xs.count = 2
  # And xs[0] = -1.0
  # And xs[1] = 1.0
  it "a ray originates inside a sphere" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, 0), RayTracer::Tuple.vector(0, 0, 1))
    s = RayTracer::Sphere.new
    xs = s.intersect(r)
    xs.size.should eq(2)
    xs[0].t.should eq(-1.0)
    xs[1].t.should eq(1.0)
  end

  # Scenario: A sphere is behind a ray
  # Given r ← ray(point(0, 0, 5), vector(0, 0, 1))
  # And s ← sphere()
  # When xs ← intersect(s, r)
  # Then xs.count = 2
  # And xs[0] = -6.0
  # And xs[1] = -4.0
  it "a sphere is behind a ray" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, 5), RayTracer::Tuple.vector(0, 0, 1))
    s = RayTracer::Sphere.new
    xs = s.intersect(r)
    xs.size.should eq(2)
    xs[0].t.should eq(-6.0)
    xs[1].t.should eq(-4.0)
  end

  # Scenario: Intersecting a scaled sphere with a ray
  # Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
  # And s ← sphere()
  # When set_transform(s, scaling(2, 2, 2))
  # And xs ← intersect(s, r)
  # Then xs.count = 2
  # And xs[0].t = 3
  # And xs[1].t = 7
  it "intersecting a scaled sphere with a ray" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, -5), RayTracer::Tuple.vector(0, 0, 1))
    s = RayTracer::Sphere.new
    s.transform = RayTracer::Matrix.scaling(2, 2, 2)
    xs = s.intersect(r)
    xs.size.should eq(2)
    xs[0].t.should eq(3)
    xs[1].t.should eq(7)
  end

  # Scenario: Intersect sets the object on the intersection
  # Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
  # And s ← sphere()
  # When xs ← intersect(s, r)
  # Then xs.count = 2
  # And xs[0].object = s
  # And xs[1].object = s
  it "intersect sets the object on the intersection" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, -5), RayTracer::Tuple.vector(0, 0, 1))
    s = RayTracer::Sphere.new
    xs = s.intersect(r)
    xs.size.should eq(2)
    xs[0].object.should eq(s)
    xs[1].object.should eq(s)
  end

  # Scenario: Intersecting a translated sphere with a ray
  # Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
  # And s ← sphere()
  # When set_transform(s, translation(5, 0, 0))
  # And xs ← intersect(s, r)
  # Then xs.count = 0
  it "intersecting a translated sphere with a ray" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, -5), RayTracer::Tuple.vector(0, 0, 1))
    s = RayTracer::Sphere.new
    s.transform = RayTracer::Matrix.translation(5, 0, 0)
    xs = s.intersect(r)
    xs.size.should eq(0)
  end

  # Scenario: The normal on a sphere at a point on the x axis
  #   Given s ← sphere()
  #   When n ← normal_at(s, point(1, 0, 0))
  #   Then n = vector(1, 0, 0)
  it "the normal on a sphere at a point on the x axis" do
    s = RayTracer::Sphere.new
    n = s.normal_at(RayTracer::Tuple.point(1, 0, 0))
    n.should eq(RayTracer::Tuple.vector(1, 0, 0))
  end

  # Scenario: The normal on a sphere at a point on the y axis
  #   Given s ← sphere()
  #   When n ← normal_at(s, point(0, 1, 0))
  #   Then n = vector(0, 1, 0)
  it "the normal on a sphere at a point on the y axis" do
    s = RayTracer::Sphere.new
    n = s.normal_at(RayTracer::Tuple.point(0, 1, 0))
    n.should eq(RayTracer::Tuple.vector(0, 1, 0))
  end

  # Scenario: The normal on a sphere at a point on the z axis
  #   Given s ← sphere()
  #   When n ← normal_at(s, point(0, 0, 1))
  #   Then n = vector(0, 0, 1)
  it "the normal on a sphere at a point on the z axis" do
    s = RayTracer::Sphere.new
    n = s.normal_at(RayTracer::Tuple.point(0, 0, 1))
    n.should eq(RayTracer::Tuple.vector(0, 0, 1))
  end

  # Scenario: The normal on a sphere at a nonaxial point
  #   Given s ← sphere()
  #   When n ← normal_at(s, point(√3/3, √3/3, √3/3))
  #   Then n = vector(√3/3, √3/3, √3/3)
  it "the normal on a sphere at a nonaxial point" do
    s = RayTracer::Sphere.new
    sq3 = Math.sqrt(3) / 3
    n = s.normal_at(RayTracer::Tuple.point(sq3, sq3, sq3))
    n.should eq(RayTracer::Tuple.vector(sq3, sq3, sq3))
  end

  # Scenario: The normal is a normalized vector
  #   Given s ← sphere()
  #   When n ← normal_at(s, point(√3/3, √3/3, √3/3))
  #   Then n = normalize(n)
  it "the normal is a normalized vector" do
    s = RayTracer::Sphere.new
    sq3 = Math.sqrt(3) / 3
    n = s.normal_at(RayTracer::Tuple.point(sq3, sq3, sq3))
    n.should eq(n.normalize)
  end

  # Scenario: Computing the normal on a translated sphere
  #   Given s ← sphere()
  #     And set_transform(s, translation(0, 1, 0))
  #   When n ← normal_at(s, point(0, 1.70711, -0.70711))
  #   Then n = vector(0, 0.70711, -0.70711)
  it "computing the normal on a translated sphere" do
    s = RayTracer::Sphere.new
    s.transform = RayTracer::Matrix.translation(0, 1, 0)
    n = s.normal_at(RayTracer::Tuple.point(0, 1.70711, -0.70711))
    n.should be_close(RayTracer::Tuple.vector(0, 0.70711, -0.70711), RayTracer::EPSILON)
  end

  # Scenario: Computing the normal on a transformed sphere
  #   Given s ← sphere()
  #     And m ← scaling(1, 0.5, 1) * rotation_z(π/5)
  #     And set_transform(s, m)
  #   When n ← normal_at(s, point(0, √2/2, -√2/2))
  #   Then n = vector(0, 0.97014, -0.24254)
  it "computing the normal on a translated sphere" do
    s = RayTracer::Sphere.new
    s.transform = RayTracer::Matrix.scaling(1, 0.5, 1) * RayTracer::Matrix.rotation_z(Math::PI / 5)
    sq2 = Math.sqrt(2) / 2
    n = s.normal_at(RayTracer::Tuple.point(0, sq2, -sq2))
    n.should be_close(RayTracer::Tuple.vector(0, 0.97014, -0.24254), RayTracer::EPSILON)
  end

  # Scenario: A sphere has a default material
  #   Given s ← sphere()
  #   When m ← s.material
  #   Then m = material()
  it "a sphere has a default material" do
    s = RayTracer::Sphere.new
    m = s.material
    m.should eq(RayTracer::Material.new)
  end

  # Scenario: A sphere may be assigned a material
  #   Given s ← sphere()
  #     And m ← material()
  #     And m.ambient ← 1
  #   When s.material ← m
  #   Then s.material = m
  it "a sphere may be assigned a material" do
    s = RayTracer::Sphere.new
    m = RayTracer::Material.new
    m.ambient = 1
    s.material = m
    s.material.should eq(m)
  end
end
