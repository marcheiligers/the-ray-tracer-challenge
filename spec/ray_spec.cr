require "./spec_helper"

describe RayTracer::Ray do
  # Scenario: Creating and querying a ray
  # Given origin ← point(1, 2, 3)
  # And direction ← vector(4, 5, 6)
  # When r ← ray(origin, direction)
  # Then r.origin = origin
  # And r.direction = direction
  it "creating and querying a ray" do
    origin = RayTracer::Tuple.point(1, 2, 3)
    direction = RayTracer::Tuple.vector(4, 5, 6)
    r = RayTracer::Ray.new(origin, direction)
    r.origin.should eq(origin)
    r.direction.should eq(direction)
  end

  # Scenario: Computing a point from a distance
  # Given r ← ray(point(2, 3, 4), vector(1, 0, 0))
  # Then position(r, 0) = point(2, 3, 4)
  # And position(r, 1) = point(3, 3, 4)
  # And position(r, -1) = point(1, 3, 4)
  # And position(r, 2.5) = point(4.5, 3, 4)
  it "computing a point from a distance" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(2, 3, 4), RayTracer::Tuple.vector(1, 0, 0))
    r.position(0).should eq(RayTracer::Tuple.point(2, 3, 4))
    r.position(1).should eq(RayTracer::Tuple.point(3, 3, 4))
    r.position(-1).should eq(RayTracer::Tuple.point(1, 3, 4))
    r.position(2.5).should eq(RayTracer::Tuple.point(4.5, 3, 4))
  end

  # Scenario: Translating a ray
  # Given r ← ray(point(1, 2, 3), vector(0, 1, 0))
  # And m ← translation(3, 4, 5)
  # When r2 ← transform(r, m)
  # Then r2.origin = point(4, 6, 8)
  # And r2.direction = vector(0, 1, 0)
  it "translating a ray" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(1, 2, 3), RayTracer::Tuple.vector(0, 1, 0))
    m = RayTracer::Matrix.translation(3, 4, 5)
    r2 = r.transform(m)
    r2.origin.should eq(RayTracer::Tuple.point(4, 6, 8))
    r2.direction.should eq(RayTracer::Tuple.vector(0, 1, 0))
  end

  # Scenario: Scaling a ray
  # Given r ← ray(point(1, 2, 3), vector(0, 1, 0))
  # And m ← scaling(2, 3, 4)
  # When r2 ← transform(r, m)
  # Then r2.origin = point(2, 6, 12)
  # And r2.direction = vector(0, 3, 0)
  it "scaling a ray" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(1, 2, 3), RayTracer::Tuple.vector(0, 1, 0))
    m = RayTracer::Matrix.scaling(2, 3, 4)
    r2 = r.transform(m)
    r2.origin.should eq(RayTracer::Tuple.point(2, 6, 12))
    r2.direction.should eq(RayTracer::Tuple.vector(0, 3, 0))
  end
end
