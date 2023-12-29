require "./spec_helper"

describe RayTracer::Shape do
  # Scenario: The default transformation
  #   Given s ← test_shape()
  #   Then s.transform = identity_matrix
  it "a shape's default transformation" do
    s = RayTracer::Shape.new
    s.transform.should eq(RayTracer::Matrix::IDENTITY_4)
  end

  # Scenario: Assigning a transformation
  #   Given s ← test_shape()
  #   When set_transform(s, translation(2, 3, 4))
  #   Then s.transform = translation(2, 3, 4)
  it "Changing a shape's transformation" do
    s = RayTracer::Shape.new
    t = RayTracer::Matrix.translation(2, 3, 4)
    s.transform = t
    s.transform.should eq(t)
  end

  # Scenario: The default material
  #   Given s ← test_shape()
  #   When m ← s.material
  #   Then m = material()
  it "a shape has a default material" do
    s = RayTracer::Shape.new
    m = s.material
    m.should eq(RayTracer::Material.new)
  end

  # Scenario: Assigning a material
  #   Given s ← test_shape()
  #     And m ← material()
  #     And m.ambient ← 1
  #   When s.material ← m
  #   Then s.material = m
  it "a shape may be assigned a material" do
    s = RayTracer::Shape.new
    m = RayTracer::Material.new
    m.ambient = 1
    s.material = m
    s.material.should eq(m)
  end

  # Scenario: Intersecting a scaled shape with a ray
  #   Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
  #     And s ← test_shape()
  #   When set_transform(s, scaling(2, 2, 2))
  #     And xs ← intersect(s, r)
  #   Then s.saved_ray.origin = point(0, 0, -2.5)
  #     And s.saved_ray.direction = vector(0, 0, 0.5)
  it "intersecting a scaled shape with a ray" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, -5), RayTracer::Tuple.vector(0, 0, 1))
    s = RayTracer::TestShape.new
    s.transform = RayTracer::Matrix.scaling(2, 2, 2)
    xs = s.intersect(r)
    s.saved_ray.as(RayTracer::Ray).origin.should eq(RayTracer::Tuple.point(0, 0, -2.5))
    s.saved_ray.as(RayTracer::Ray).direction.should eq(RayTracer::Tuple.vector(0, 0, 0.5))
  end

  # Scenario: Intersecting a translated shape with a ray
  #   Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
  #     And s ← test_shape()
  #   When set_transform(s, translation(5, 0, 0))
  #     And xs ← intersect(s, r)
  #   Then s.saved_ray.origin = point(-5, 0, -5)
  #     And s.saved_ray.direction = vector(0, 0, 1)
  it "intersecting a translated shape with a ray" do
    r = RayTracer::Ray.new(RayTracer::Tuple.point(0, 0, -5), RayTracer::Tuple.vector(0, 0, 1))
    s = RayTracer::TestShape.new
    s.transform = RayTracer::Matrix.translation(5, 0, 0)
    xs = s.intersect(r)
    s.saved_ray.as(RayTracer::Ray).origin.should eq(RayTracer::Tuple.point(-5, 0, -5))
    s.saved_ray.as(RayTracer::Ray).direction.should eq(RayTracer::Tuple.vector(0, 0, 1))
  end

  # Scenario: Computing the normal on a translated shape
  #   Given s ← test_shape()
  #   When set_transform(s, translation(0, 1, 0))
  #     And n ← normal_at(s, point(0, 1.70711, -0.70711))
  #   Then n = vector(0, 0.70711, -0.70711)
  it "computing the normal on a translated shape" do
    s = RayTracer::TestShape.new
    s.transform = RayTracer::Matrix.translation(0, 1, 0)
    n = s.normal_at(RayTracer::Tuple.point(0, 1.70711, -0.70711))
    n.should be_close(RayTracer::Tuple.vector(0, 0.70711, -0.70711), RayTracer::EPSILON)
  end

  # Scenario: Computing the normal on a transformed shape
  #   Given s ← test_shape()
  #     And m ← scaling(1, 0.5, 1) * rotation_z(π/5)
  #   When set_transform(s, m)
  #     And n ← normal_at(s, point(0, √2/2, -√2/2))
  #   Then n = vector(0, 0.97014, -0.24254)
  it "computing the normal on a translated shape" do
    s = RayTracer::TestShape.new
    s.transform = RayTracer::Matrix.scaling(1, 0.5, 1) * RayTracer::Matrix.rotation_z(Math::PI / 5)
    sq2 = Math.sqrt(2) / 2
    n = s.normal_at(RayTracer::Tuple.point(0, sq2, -sq2))
    n.should be_close(RayTracer::Tuple.vector(0, 0.97014, -0.24254), RayTracer::EPSILON)
  end
end
