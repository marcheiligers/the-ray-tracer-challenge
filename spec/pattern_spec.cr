require "./spec_helper"

describe RayTracer::StripePattern do
  # Scenario: Creating a stripe pattern
  #   Given pattern ← stripe_pattern(white, black)
  #   Then pattern.a = white
  #     And pattern.b = black
  it "creating a stripe pattern" do
    p = RayTracer::StripePattern.new(RayTracer::Color::WHITE, RayTracer::Color::BLACK)
    p.a.as(RayTracer::SolidPattern).color.should eq(RayTracer::Color::WHITE)
    p.b.as(RayTracer::SolidPattern).color.should eq(RayTracer::Color::BLACK)
  end

  # Scenario: A stripe pattern is constant in y
  #   Given pattern ← stripe_pattern(white, black)
  #   Then stripe_at(pattern, point(0, 0, 0)) = white
  #     And stripe_at(pattern, point(0, 1, 0)) = white
  #     And stripe_at(pattern, point(0, 2, 0)) = white
  it "a stripe pattern is constant in y" do
    p = RayTracer::StripePattern.new(RayTracer::Color::WHITE, RayTracer::Color::BLACK)
    p.pattern_at(RayTracer::Tuple.point(0, 0, 0)).should eq(RayTracer::Color::WHITE)
    p.pattern_at(RayTracer::Tuple.point(0, 1, 0)).should eq(RayTracer::Color::WHITE)
    p.pattern_at(RayTracer::Tuple.point(0, 2, 0)).should eq(RayTracer::Color::WHITE)
  end

  # Scenario: A stripe pattern is constant in z
  #   Given pattern ← stripe_pattern(white, black)
  #   Then stripe_at(pattern, point(0, 0, 0)) = white
  #     And stripe_at(pattern, point(0, 0, 1)) = white
  #     And stripe_at(pattern, point(0, 0, 2)) = white
  it "a stripe pattern is constant in z" do
    p = RayTracer::StripePattern.new(RayTracer::Color::WHITE, RayTracer::Color::BLACK)
    p.pattern_at(RayTracer::Tuple.point(0, 0, 0)).should eq(RayTracer::Color::WHITE)
    p.pattern_at(RayTracer::Tuple.point(0, 0, 1)).should eq(RayTracer::Color::WHITE)
    p.pattern_at(RayTracer::Tuple.point(0, 0, 2)).should eq(RayTracer::Color::WHITE)
  end

  # Scenario: A stripe pattern alternates in x
  #   Given pattern ← stripe_pattern(white, black)
  #   Then stripe_at(pattern, point(0, 0, 0)) = white
  #     And stripe_at(pattern, point(0.9, 0, 0)) = white
  #     And stripe_at(pattern, point(1, 0, 0)) = black
  #     And stripe_at(pattern, point(-0.1, 0, 0)) = black
  #     And stripe_at(pattern, point(-1, 0, 0)) = black
  #     And stripe_at(pattern, point(-1.1, 0, 0)) = white
  it "a stripe pattern alternates in x" do
    p = RayTracer::StripePattern.new(RayTracer::Color::WHITE, RayTracer::Color::BLACK)
    p.pattern_at(RayTracer::Tuple.point(0, 0, 0)).should eq(RayTracer::Color::WHITE)
    p.pattern_at(RayTracer::Tuple.point(0.9, 0, 0)).should eq(RayTracer::Color::WHITE)
    p.pattern_at(RayTracer::Tuple.point(1, 0, 0)).should eq(RayTracer::Color::BLACK)
    p.pattern_at(RayTracer::Tuple.point(-0.1, 0, 0)).should eq(RayTracer::Color::BLACK)
    p.pattern_at(RayTracer::Tuple.point(-1, 0, 0)).should eq(RayTracer::Color::BLACK)
    p.pattern_at(RayTracer::Tuple.point(-1.1, 0, 0)).should eq(RayTracer::Color::WHITE)
  end

  # Scenario: Stripes with an object transformation
  #   Given object ← sphere()
  #     And set_transform(object, scaling(2, 2, 2))
  #     And pattern ← stripe_pattern(white, black)
  #   When c ← stripe_at_object(pattern, object, point(1.5, 0, 0))
  #   Then c = white
  it "stripes with an object transformation" do
    object = RayTracer::Sphere.new
    object.transform = RayTracer::Matrix.scaling(2, 2, 2)
    pattern = RayTracer::StripePattern.new(RayTracer::Color::WHITE, RayTracer::Color::BLACK)
    c = pattern.pattern_at_shape(object, RayTracer::Tuple.point(1.5, 0, 0))
    c.should eq(RayTracer::Color::WHITE)
  end

  # Scenario: Stripes with a pattern transformation
  #   Given object ← sphere()
  #     And pattern ← stripe_pattern(white, black)
  #     And set_pattern_transform(pattern, scaling(2, 2, 2))
  #   When c ← stripe_at_object(pattern, object, point(1.5, 0, 0))
  #   Then c = white
  it "stripes with a pattern transformation" do
    object = RayTracer::Sphere.new
    pattern = RayTracer::StripePattern.new(RayTracer::Color::WHITE, RayTracer::Color::BLACK)
    pattern.transform = RayTracer::Matrix.scaling(2, 2, 2)
    c = pattern.pattern_at_shape(object, RayTracer::Tuple.point(1.5, 0, 0))
    c.should eq(RayTracer::Color::WHITE)
  end

  # Scenario: Stripes with both an object and a pattern transformation
  #   Given object ← sphere()
  #     And set_transform(object, scaling(2, 2, 2))
  #     And pattern ← stripe_pattern(white, black)
  #     And set_pattern_transform(pattern, translation(0.5, 0, 0))
  #   When c ← stripe_at_object(pattern, object, point(2.5, 0, 0))
  #   Then c = white
  it "stripes with a pattern transformation" do
    object = RayTracer::Sphere.new
    object.transform = RayTracer::Matrix.scaling(2, 2, 2)
    pattern = RayTracer::StripePattern.new(RayTracer::Color::WHITE, RayTracer::Color::BLACK)
    pattern.transform = RayTracer::Matrix.translation(0.5, 0, 0)
    c = pattern.pattern_at_shape(object, RayTracer::Tuple.point(2.5, 0, 0))
    c.should eq(RayTracer::Color::WHITE)
  end

  # Scenario: The default pattern transformation
  #   Given pattern ← test_pattern()
  #   Then pattern.transform = identity_matrix
  it "the default pattern transformation" do
    pattern = RayTracer::TestPattern.new
    pattern.transform.should eq(RayTracer::Matrix::IDENTITY_4)
  end

  # Scenario: Assigning a transformation
  #   Given pattern ← test_pattern()
  #   When set_pattern_transform(pattern, translation(1, 2, 3))
  #   Then pattern.transform = translation(1, 2, 3)
  it "assigning a transformation" do
    pattern = RayTracer::TestPattern.new
    pattern.transform = RayTracer::Matrix.translation(1, 2, 3)
    pattern.transform.should eq(RayTracer::Matrix.translation(1, 2, 3))
  end

  # Scenario: A pattern with an object transformation
  #   Given shape ← sphere()
  #     And set_transform(shape, scaling(2, 2, 2))
  #     And pattern ← test_pattern()
  #   When c ← pattern_at_shape(pattern, shape, point(2, 3, 4))
  #   Then c = color(1, 1.5, 2)
  it "a pattern with an object transformation" do
    shape = RayTracer::Sphere.new
    shape.transform = RayTracer::Matrix.scaling(2, 2, 2)
    pattern = RayTracer::TestPattern.new
    c = pattern.pattern_at_shape(shape, RayTracer::Tuple.point(2, 3, 4))
    c.should eq(RayTracer::Color.color(1, 1.5, 2))
  end

  # Scenario: A pattern with a pattern transformation
  #   Given shape ← sphere()
  #     And pattern ← test_pattern()
  #     And set_pattern_transform(pattern, scaling(2, 2, 2))
  #   When c ← pattern_at_shape(pattern, shape, point(2, 3, 4))
  #   Then c = color(1, 1.5, 2)
  it "a pattern with a pattern transformation" do
    shape = RayTracer::Sphere.new
    pattern = RayTracer::TestPattern.new
    pattern.transform = RayTracer::Matrix.scaling(2, 2, 2)
    c = pattern.pattern_at_shape(shape, RayTracer::Tuple.point(2, 3, 4))
    c.should eq(RayTracer::Color.color(1, 1.5, 2))
  end

  # Scenario: A pattern with both an object and a pattern transformation
  #   Given shape ← sphere()
  #     And set_transform(shape, scaling(2, 2, 2))
  #     And pattern ← test_pattern()
  #     And set_pattern_transform(pattern, translation(0.5, 1, 1.5))
  #   When c ← pattern_at_shape(pattern, shape, point(2.5, 3, 3.5))
  #   Then c = color(0.75, 0.5, 0.25)
  it "a pattern with both an object and a pattern transformation" do
    shape = RayTracer::Sphere.new
    shape.transform = RayTracer::Matrix.scaling(2, 2, 2)
    pattern = RayTracer::TestPattern.new
    pattern.transform = RayTracer::Matrix.translation(0.5, 1, 1.5)
    c = pattern.pattern_at_shape(shape, RayTracer::Tuple.point(2.5, 3, 3.5))
    c.should eq(RayTracer::Color.color(0.75, 0.5, 0.25))
  end

  # Scenario: A gradient linearly interpolates between colors
  #   Given pattern ← gradient_pattern(white, black)
  #   Then pattern_at(pattern, point(0, 0, 0)) = white
  #     And pattern_at(pattern, point(0.25, 0, 0)) = color(0.75, 0.75, 0.75)
  #     And pattern_at(pattern, point(0.5, 0, 0)) = color(0.5, 0.5, 0.5)
  #     And pattern_at(pattern, point(0.75, 0, 0)) = color(0.25, 0.25, 0.25)
  it "a gradient linearly interpolates between colors" do
    p = RayTracer::GradientPattern.new(RayTracer::Color::WHITE, RayTracer::Color::BLACK)
    p.pattern_at(RayTracer::Tuple.point(0, 0, 0)).should eq(RayTracer::Color::WHITE)
    p.pattern_at(RayTracer::Tuple.point(0.25, 0, 0)).should eq(RayTracer::Color.color(0.75, 0.75, 0.75))
    p.pattern_at(RayTracer::Tuple.point(0.5, 0, 0)).should eq(RayTracer::Color.color(0.5, 0.5, 0.5))
    p.pattern_at(RayTracer::Tuple.point(0.75, 0, 0)).should eq(RayTracer::Color.color(0.25, 0.25, 0.25))
  end

  # Scenario: A ring should extend in both x and z
  #   Given pattern ← ring_pattern(white, black)
  #   Then pattern_at(pattern, point(0, 0, 0)) = white
  #     And pattern_at(pattern, point(1, 0, 0)) = black
  #     And pattern_at(pattern, point(0, 0, 1)) = black
  #     # 0.708 = just slightly more than √2/2
  #     And pattern_at(pattern, point(0.708, 0, 0.708)) = black
  it "a ring should extend in both x and z" do
    p = RayTracer::RingPattern.new(RayTracer::Color::WHITE, RayTracer::Color::BLACK)
    p.pattern_at(RayTracer::Tuple.point(0, 0, 0)).should eq(RayTracer::Color::WHITE)
    p.pattern_at(RayTracer::Tuple.point(1, 0, 0)).should eq(RayTracer::Color::BLACK)
    p.pattern_at(RayTracer::Tuple.point(0, 0, 1)).should eq(RayTracer::Color::BLACK)
    p.pattern_at(RayTracer::Tuple.point(0.708, 0, 0.708)).should eq(RayTracer::Color::BLACK)
  end

  # Scenario: Checkers should repeat in x
  #   Given pattern ← checkers_pattern(white, black)
  #   Then pattern_at(pattern, point(0, 0, 0)) = white
  #     And pattern_at(pattern, point(0.99, 0, 0)) = white
  #     And pattern_at(pattern, point(1.01, 0, 0)) = black
  it "checkers should repeat in x" do
    p = RayTracer::CheckersPattern.new(RayTracer::Color::WHITE, RayTracer::Color::BLACK)
    p.pattern_at(RayTracer::Tuple.point(0, 0, 0)).should eq(RayTracer::Color::WHITE)
    p.pattern_at(RayTracer::Tuple.point(0.99, 0, 0)).should eq(RayTracer::Color::WHITE)
    p.pattern_at(RayTracer::Tuple.point(1.01, 0, 0)).should eq(RayTracer::Color::BLACK)
  end

  # Scenario: Checkers should repeat in y
  #   Given pattern ← checkers_pattern(white, black)
  #   Then pattern_at(pattern, point(0, 0, 0)) = white
  #     And pattern_at(pattern, point(0, 0.99, 0)) = white
  #     And pattern_at(pattern, point(0, 1.01, 0)) = black
  it "checkers should repeat in y" do
    p = RayTracer::CheckersPattern.new(RayTracer::Color::WHITE, RayTracer::Color::BLACK)
    p.pattern_at(RayTracer::Tuple.point(0, 0, 0)).should eq(RayTracer::Color::WHITE)
    p.pattern_at(RayTracer::Tuple.point(0, 0.99, 0)).should eq(RayTracer::Color::WHITE)
    p.pattern_at(RayTracer::Tuple.point(0, 1.01, 0)).should eq(RayTracer::Color::BLACK)
  end

  # Scenario: Checkers should repeat in z
  #   Given pattern ← checkers_pattern(white, black)
  #   Then pattern_at(pattern, point(0, 0, 0)) = white
  #     And pattern_at(pattern, point(0, 0, 0.99)) = white
  #     And pattern_at(pattern, point(0, 0, 1.01)) = black
  it "checkers should repeat in y" do
    p = RayTracer::CheckersPattern.new(RayTracer::Color::WHITE, RayTracer::Color::BLACK)
    p.pattern_at(RayTracer::Tuple.point(0, 0, 0)).should eq(RayTracer::Color::WHITE)
    p.pattern_at(RayTracer::Tuple.point(0, 0, 0.99)).should eq(RayTracer::Color::WHITE)
    p.pattern_at(RayTracer::Tuple.point(0, 0, 1.01)).should eq(RayTracer::Color::BLACK)
  end
end
