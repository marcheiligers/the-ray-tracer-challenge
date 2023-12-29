require "./spec_helper"

describe RayTracer::Shape do
  # Scenario: The normal of a plane is constant everywhere
  #   Given p ← plane()
  #   When n1 ← local_normal_at(p, point(0, 0, 0))
  #     And n2 ← local_normal_at(p, point(10, 0, -10))
  #     And n3 ← local_normal_at(p, point(-5, 0, 150))
  #   Then n1 = vector(0, 1, 0)
  #     And n2 = vector(0, 1, 0)
  #     And n3 = vector(0, 1, 0)
  it "the normal of a plane is constant everywhere" do
    p = RayTracer::Plane.new
    n1 = p.local_normal_at(RayTracer::Tuple.point(0, 0, 0))
    n2 = p.local_normal_at(RayTracer::Tuple.point(10, 0, -10))
    n3 = p.local_normal_at(RayTracer::Tuple.point(-5, 0, 150))
    n1.should eq(RayTracer::Tuple.vector(0, 1, 0))
    n2.should eq(RayTracer::Tuple.vector(0, 1, 0))
    n3.should eq(RayTracer::Tuple.vector(0, 1, 0))
  end

  # Scenario: Intersect with a ray parallel to the plane
  #   Given p ← plane()
  #     And r ← ray(point(0, 10, 0), vector(0, 0, 1))
  #   When xs ← local_intersect(p, r)
  #   Then xs is empty
  it "intersect with a ray parallel to the plane" do
    p = RayTracer::Plane.new
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 10, 0), RayTracer::Tuple.vector(0, 0, 1))
    xs = p.local_intersect(r)
    xs.should be_empty
  end

  # Scenario: Intersect with a coplanar ray
  #   Given p ← plane()
  #     And r ← ray(point(0, 0, 0), vector(0, 0, 1))
  #   When xs ← local_intersect(p, r)
  #   Then xs is empty
  it "intersect with a coplanar ray" do
    p = RayTracer::Plane.new
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, 0), RayTracer::Tuple.vector(0, 0, 1))
    xs = p.local_intersect(r)
    xs.should be_empty
  end

  # Scenario: A ray intersecting a plane from above
  #   Given p ← plane()
  #     And r ← ray(point(0, 1, 0), vector(0, -1, 0))
  #   When xs ← local_intersect(p, r)
  #   Then xs.count = 1
  #     And xs[0].t = 1
  #     And xs[0].object = p
  it "a ray intersecting a plane from above" do
    p = RayTracer::Plane.new
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 1, 0), RayTracer::Tuple.vector(0, -1, 0))
    xs = p.local_intersect(r)
    xs.size.should eq(1)
    xs[0].t.should eq(1)
    xs[0].object.should eq(p)
  end

  # Scenario: A ray intersecting a plane from below
  #   Given p ← plane()
  #     And r ← ray(point(0, -1, 0), vector(0, 1, 0))
  #   When xs ← local_intersect(p, r)
  #   Then xs.count = 1
  #     And xs[0].t = 1
  #     And xs[0].object = p
  it "a ray intersecting a plane from below" do
    p = RayTracer::Plane.new
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, -1, 0), RayTracer::Tuple.vector(0, 1, 0))
    xs = p.local_intersect(r)
    xs.size.should eq(1)
    xs[0].t.should eq(1)
    xs[0].object.should eq(p)
  end
end
