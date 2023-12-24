require "./spec_helper"

describe RayTracer::Intersection do
  # Scenario: An intersection encapsulates t and object
  # Given s ← sphere()
  # When i ← intersection(3.5, s)
  # Then i.t = 3.5
  # And i.object = s
  it "an intersection encapsulates t and object" do
    s = RayTracer::Sphere.new
    i = RayTracer::Intersection.new(3.5, s)
    i.t.should eq(3.5)
    i.object.should eq(s)
  end

  # Scenario: Aggregating intersections
  # Given s ← sphere()
  # And i1 ← intersection(1, s)
  # And i2 ← intersection(2, s)
  # When xs ← intersections(i1, i2)
  # Then xs.count = 2
  # And xs[0].t = 1
  # And xs[1].t = 2
  it "aggregating intersections" do
    s = RayTracer::Sphere.new
    i1 = RayTracer::Intersection.new(1, s)
    i2 = RayTracer::Intersection.new(2, s)
    xs = RayTracer::Intersections.new(i1, i2)
    xs.size.should eq(2)
    xs[0].t.should eq(1)
    xs[1].t.should eq(2)
  end

  # Scenario: The hit, when all intersections have positive t
  # Given s ← sphere()
  # And i1 ← intersection(1, s)
  # And i2 ← intersection(2, s)
  # And xs ← intersections(i2, i1)
  # When i ← hit(xs)
  # Then i = i1
  it "the hit, when all intersections have positive t" do
    s = RayTracer::Sphere.new
    i1 = RayTracer::Intersection.new(1, s)
    i2 = RayTracer::Intersection.new(2, s)
    xs = RayTracer::Intersections.new(i1, i2)
    i = xs.hit
    i.should eq(i1)
  end

  # Scenario: The hit, when some intersections have negative t
  # Given s ← sphere()
  # And i1 ← intersection(-1, s)
  # And i2 ← intersection(1, s)
  # And xs ← intersections(i2, i1)
  # When i ← hit(xs)
  # Then i = i2
  it "the hit, when some intersections have negative t" do
    s = RayTracer::Sphere.new
    i1 = RayTracer::Intersection.new(-1, s)
    i2 = RayTracer::Intersection.new(1, s)
    xs = RayTracer::Intersections.new(i1, i2)
    i = xs.hit
    i.should eq(i2)
  end

  # Scenario: The hit, when all intersections have negative t
  # Given s ← sphere()
  # And i1 ← intersection(-2, s)
  # And i2 ← intersection(-1, s)
  # And xs ← intersections(i2, i1)
  # When i ← hit(xs)
  # Then i is nothing
  it "the hit, when all intersections have negative t" do
    s = RayTracer::Sphere.new
    i1 = RayTracer::Intersection.new(-2, s)
    i2 = RayTracer::Intersection.new(-1, s)
    xs = RayTracer::Intersections.new(i1, i2)
    i = xs.hit
    i.should be_nil
  end

  # Scenario: The hit is always the lowest nonnegative intersection
  # Given s ← sphere()
  # And i1 ← intersection(5, s)
  # And i2 ← intersection(7, s)
  # And i3 ← intersection(-3, s)
  # And i4 ← intersection(2, s)
  # And xs ← intersections(i1, i2, i3, i4)
  # When i ← hit(xs)
  # Then i = i4
  it "the hit is always the lowest nonnegative intersection" do
    s = RayTracer::Sphere.new
    i1 = RayTracer::Intersection.new(5, s)
    i2 = RayTracer::Intersection.new(7, s)
    i3 = RayTracer::Intersection.new(-3, s)
    i4 = RayTracer::Intersection.new(2, s)
    xs = RayTracer::Intersections.new(i1, i2, i3, i4)
    i = xs.hit
    i.should eq(i4)
  end
end
