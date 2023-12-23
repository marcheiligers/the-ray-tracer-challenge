require "./spec_helper"

describe RayTracer::Color do
  # Scenario: Colors are (red, green, blue) tuples
  # Given c ← color(-0.5, 0.4, 1.7)
  # Then c.red = -0.5
  # And c.green = 0.4
  # And c.blue = 1.7
  it "creates a color" do
    c = RayTracer::Color.color(-0.5, 0.4, 1.7)
    c.r.should eq(-0.5_f32)
    c.g.should eq(0.4_f32)
    c.b.should eq(1.7_f32)
  end

  # Scenario: Adding colors
  # Given c1 ← color(0.9, 0.6, 0.75)
  # And c2 ← color(0.7, 0.1, 0.25)
  # Then c1 + c2 = color(1.6, 0.7, 1.0)
  it "adds two colors" do
    c1 = RayTracer::Color.color(0.9, 0.6, 0.75)
    c2 = RayTracer::Color.color(0.7, 0.1, 0.25)
    (c1 + c2).should be_close(RayTracer::Color.color(1.6, 0.7, 1.0), 0.00001)
  end

  # Scenario: Subtracting colors
  # Given c1 ← color(0.9, 0.6, 0.75)
  # And c2 ← color(0.7, 0.1, 0.25)
  # Then c1 - c2 = color(0.2, 0.5, 0.5)
  it "subtracts two colors" do
    c1 = RayTracer::Color.color(0.9, 0.6, 0.75)
    c2 = RayTracer::Color.color(0.7, 0.1, 0.25)
    (c1 - c2).should be_close(RayTracer::Color.color(0.2, 0.5, 0.5), 0.00001)
  end

  # Scenario: Multiplying a color by a scalar
  # Given c ← color(0.2, 0.3, 0.4)
  # Then c * 2 = color(0.4, 0.6, 0.8)
  it "multiplies a color by a scalar" do
    c = RayTracer::Color.color(0.2, 0.3, 0.4)
    (c * 2_f32).should be_close(RayTracer::Color.color(0.4, 0.6, 0.8), 0.00001)
  end

  # Scenario: Multiplying colors
  # Given c1 ← color(1, 0.2, 0.4)
  # And c2 ← color(0.9, 1, 0.1)
  # Then c1 * c2 = color(0.9, 0.2, 0.04)
  it "multiplies two colors" do
    c1 = RayTracer::Color.color(1, 0.2, 0.4)
    c2 = RayTracer::Color.color(0.9, 1, 0.1)
    (c1 * c2).should be_close(RayTracer::Color.color(0.9, 0.2, 0.04), 0.00001)
  end
end
