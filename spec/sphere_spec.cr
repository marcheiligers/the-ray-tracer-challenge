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
    xs = r.intersects(s)
    xs.size.should eq(2)
    xs[0].t.should eq(3)
    xs[1].t.should eq(7)
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
    xs = r.intersects(s)
    xs.size.should eq(0)
  end
end
