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

  # Scenario: Precomputing the state of an intersection
  #   Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
  #     And shape ← sphere()
  #     And i ← intersection(4, shape)
  #   When comps ← prepare_computations(i, r)
  #   Then comps.t = i.t
  #     And comps.object = i.object
  #     And comps.point = point(0, 0, -1)
  #     And comps.eyev = vector(0, 0, -1)
  #     And comps.normalv = vector(0, 0, -1)
  it "precomputing the state of an intersection" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, -5), RayTracer::Tuple.vector(0, 0, 1))
    shape = RayTracer::Sphere.new
    i = RayTracer::Intersection.new(4, shape)
    comps = RayTracer::Computation.new(i, r)
    comps.t.should eq(i.t)
    comps.object.should eq(i.object)
    comps.point.should eq(RayTracer::Tuple.point(0, 0, -1))
    comps.eyev.should eq(RayTracer::Tuple.vector(0, 0, -1))
    comps.normalv.should eq(RayTracer::Tuple.vector(0, 0, -1))
  end

  # Scenario: The hit, when an intersection occurs on the outside
  #   Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
  #     And shape ← sphere()
  #     And i ← intersection(4, shape)
  #   When comps ← prepare_computations(i, r)
  #   Then comps.inside = false
  it "the hit, when an intersection occurs on the outside" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, -5), RayTracer::Tuple.vector(0, 0, 1))
    shape = RayTracer::Sphere.new
    i = RayTracer::Intersection.new(4, shape)
    comps = RayTracer::Computation.new(i, r)
    comps.inside?.should be_false
  end

  # Scenario: The hit, when an intersection occurs on the inside
  #   Given r ← ray(point(0, 0, 0), vector(0, 0, 1))
  #     And shape ← sphere()
  #     And i ← intersection(1, shape)
  #   When comps ← prepare_computations(i, r)
  #   Then comps.point = point(0, 0, 1)
  #     And comps.eyev = vector(0, 0, -1)
  #     And comps.inside = true
  #       # normal would have been (0, 0, 1), but is inverted!
  #     And comps.normalv = vector(0, 0, -1)
  it "the hit, when an intersection occurs on the inside" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, 0), RayTracer::Tuple.vector(0, 0, 1))
    shape = RayTracer::Sphere.new
    i = RayTracer::Intersection.new(1, shape)
    comps = RayTracer::Computation.new(i, r)
    comps.point.should eq(RayTracer::Tuple.point(0, 0, 1))
    comps.eyev.should eq(RayTracer::Tuple.vector(0, 0, -1))
    comps.inside?.should be_true
    comps.normalv.should eq(RayTracer::Tuple.vector(0, 0, -1))
  end

  # Scenario: The hit should offset the point
  #   Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
  #     And shape ← sphere() with:
  #       | transform | translation(0, 0, 1) |
  #     And i ← intersection(5, shape)
  #   When comps ← prepare_computations(i, r)
  #   Then comps.over_point.z < -EPSILON/2
  #     And comps.point.z > comps.over_point.z
  it "the hit should offset the point" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, -5), RayTracer::Tuple.vector(0, 0, 1))
    shape = RayTracer::Sphere.new
    transform = RayTracer::Matrix.translation(0, 0, 1)
    shape.transform = transform
    i = RayTracer::Intersection.new(5, shape)

    comps = RayTracer::Computation.new(i, r)
    (comps.over_point.z < -RayTracer::EPSILON/2).should be_true
    (comps.point.z > comps.over_point.z).should be_true
  end
end
