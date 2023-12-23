require "./spec_helper"

describe RayTracer::Tuple do
  # Scenario: A tuple with w=1.0 is a point
  # Given a ← tuple(4.3, -4.2, 3.1, 1.0)
  # Then a.x = 4.3
  # And a.y = -4.2
  # And a.z = 3.1
  # And a.w = 1.0
  # And a is a point
  # And a is not a vector
  it "is a point" do
    a = {x: 4.3, y: -4.2, z: 3.1, w: 1.0}
    a[:x].should eq(4.3)
    a[:y].should eq(-4.2)
    a[:z].should eq(3.1)
    a[:w].should eq(1.0)
    RayTracer::Tuple.point?(a).should eq(true)
    RayTracer::Tuple.vector?(a).should eq(false)
  end

  it "is a point with accessors" do
    a = {x: 4.3, y: -4.2, z: 3.1, w: 1.0}
    a.x.should eq(4.3)
    a.y.should eq(-4.2)
    a.z.should eq(3.1)
    a.w.should eq(1.0)
    a.point?.should eq(true)
    a.vector?.should eq(false)
  end

  # Scenario: A tuple with w=0 is a vector
  # Given a ← tuple(4.3, -4.2, 3.1, 0.0)
  # Then a.x = 4.3
  # And a.y = -4.2
  # And a.z = 3.1
  # And a.w = 0.0
  # And a is not a point And a is a vector
  it "is a vector" do
    a = {x: 4.3, y: -4.2, z: 3.1, w: 0.0}
    a[:x].should eq(4.3)
    a[:y].should eq(-4.2)
    a[:z].should eq(3.1)
    a[:w].should eq(0.0)
    RayTracer::Tuple.point?(a).should eq(false)
    RayTracer::Tuple.vector?(a).should eq(true)
  end

  it "is a vector with accessors" do
    a = {x: 4.3, y: -4.2, z: 3.1, w: 0.0}
    a.x.should eq(4.3)
    a.y.should eq(-4.2)
    a.z.should eq(3.1)
    a.w.should eq(0.0)
    a.point?.should eq(false)
    a.vector?.should eq(true)
  end

  # Scenario: point() creates tuples with w=1 Given p ← point(4, -4, 3)
  # Then p = tuple(4, -4, 3, 1)
  it "creates a point" do
    RayTracer::Tuple.point(4, -4, 3).should eq({x: 4.0, y: -4.0, z: 3.0, w: 1.0})
  end

  # Scenario: vector() creates tuples with w=0 Given v ← vector(4, -4, 3)
  # Then v = tuple(4, -4, 3, 0)
  it "creates a vector" do
    RayTracer::Tuple.vector(4, -4, 3).should eq({x: 4.0, y: -4.0, z: 3.0, w: 0.0})
  end

  # Scenario: Adding two tuples
  # Given a1 ← tuple(3, -2, 5, 1)
  # And a2 ← tuple(-2, 3, 1, 0)
  # Then a1 + a2 = tuple(1, 1, 6, 1)
  it "adds points and vectors" do
    a1 = RayTracer::Tuple.point(3, -2, 5)
    a2 = RayTracer::Tuple.vector(-2, 3, 1)
    RayTracer::Tuple.add(a1, a2).should eq({x: 1.0, y: 1.0, z: 6.0, w: 1.0})
  end

  it "adds points and vectors with +" do
    a1 = RayTracer::Tuple.point(3, -2, 5)
    a2 = RayTracer::Tuple.vector(-2, 3, 1)
    (a1 + a2).should eq({x: 1.0, y: 1.0, z: 6.0, w: 1.0})
  end

  # Scenario: Subtracting two points
  # Given p1 ← point(3, 2, 1)
  # And p2 ← point(5, 6, 7)
  # Then p1 - p2 = vector(-2, -4, -6)
  it "subtracts points" do
    a1 = RayTracer::Tuple.point(3, 2, 1)
    a2 = RayTracer::Tuple.point(5, 6, 7)
    RayTracer::Tuple.subtract(a1, a2).should eq(RayTracer::Tuple.vector(-2, -4, -6))
  end

  it "subtracts points with -" do
    a1 = RayTracer::Tuple.point(3, 2, 1)
    a2 = RayTracer::Tuple.point(5, 6, 7)
    (a1 - a2).should eq(RayTracer::Tuple.vector(-2, -4, -6))
  end

  # Scenario: Subtracting a vector from a point
  # Given p ← point(3, 2, 1)
  # And v ← vector(5, 6, 7)
  # Then p - v = point(-2, -4, -6)
  it "subtracts a vector from a point" do
    a1 = RayTracer::Tuple.point(3, 2, 1)
    a2 = RayTracer::Tuple.vector(5, 6, 7)
    RayTracer::Tuple.subtract(a1, a2).should eq(RayTracer::Tuple.point(-2, -4, -6))
  end

  # Scenario: Subtracting two vectors
  # Given v1 ← vector(3, 2, 1)
  # And v2 ← vector(5, 6, 7)
  # Then v1 - v2 = vector(-2, -4, -6)
  it "subtracts vectors" do
    a1 = RayTracer::Tuple.vector(3, 2, 1)
    a2 = RayTracer::Tuple.vector(5, 6, 7)
    RayTracer::Tuple.subtract(a1, a2).should eq(RayTracer::Tuple.vector(-2, -4, -6))
  end

  # Scenario: Subtracting a vector from the zero vector
  # Given zero ← vector(0, 0, 0)
  # And v ← vector(1, -2, 3)
  # Then zero - v = vector(-1, 2, -3)
  it "subtracts from the zero vector" do
    a1 = RayTracer::Tuple.vector(0, 0, 0)
    a2 = RayTracer::Tuple.vector(1, -2, 3)
    RayTracer::Tuple.subtract(a1, a2).should eq(RayTracer::Tuple.vector(-1, 2, -3))
  end

  # Scenario: Negating a tuple
  # Given a ← tuple(1, -2, 3, -4)
  # Then -a = tuple(-1, 2, -3, 4)
  it "negates a tuple" do
    a = {x: 1.0, y: -2.0, z: 3.0, w: -4.0}
    RayTracer::Tuple.negate(a).should eq({x: -1, y: 2, z: -3, w: 4})
  end

  it "negates a tuple with -" do
    a = {x: 1.0, y: -2.0, z: 3.0, w: -4.0}
    (-a).should eq({x: -1, y: 2, z: -3, w: 4})
  end

  # Scenario: Multiplying a tuple by a scalar
  # Given a ← tuple(1, -2, 3, -4)
  # Then a * 3.5 = tuple(3.5, -7, 10.5, -14)
  it "scales a tuple by a scalar" do
    a = RayTracer::Tuple.tuple(1, -2, 3, -4)
    RayTracer::Tuple.multiply(a, 3.5).should eq(RayTracer::Tuple.tuple(3.5, -7, 10.5, -14))
  end

  it "scales a tuple by a scalar with *" do
    a = RayTracer::Tuple.tuple(1, -2, 3, -4)
    (a * 3.5).should eq(RayTracer::Tuple.tuple(3.5, -7, 10.5, -14))
  end

  # Scenario: Multiplying a tuple by a fraction
  # Given a ← tuple(1, -2, 3, -4)
  # Then a * 0.5 = tuple(0.5, -1, 1.5, -2)
  it "scales a tuple by a fraction" do
    a = RayTracer::Tuple.tuple(1, -2, 3, -4)
    RayTracer::Tuple.multiply(a, 0.5).should eq(RayTracer::Tuple.tuple(0.5, -1, 1.5, -2))
  end

  it "scales a tuple by a fraction with *" do
    a = RayTracer::Tuple.tuple(1, -2, 3, -4)
    (a * 0.5).should eq(RayTracer::Tuple.tuple(0.5, -1, 1.5, -2))
  end

  # Scenario: Dividing a tuple by a scalar
  # Given a ← tuple(1, -2, 3, -4)
  # Then a / 2 = tuple(0.5, -1, 1.5, -2)
  it "divides a tuple by a scalar" do
    a = RayTracer::Tuple.tuple(1, -2, 3, -4)
    RayTracer::Tuple.divide(a, 2).should eq(RayTracer::Tuple.tuple(0.5, -1, 1.5, -2))
  end

  it "divides a tuple by a scalar with /" do
    a = RayTracer::Tuple.tuple(1, -2, 3, -4)
    (a / 2).should eq(RayTracer::Tuple.tuple(0.5, -1, 1.5, -2))
  end

  # Scenario: Computing the magnitude of vector(1, 0, 0)
  # Given v ← vector(1, 0, 0)
  # Then magnitude(v) = 1
  it "returns the magnitude of a vector with x = 1" do
    a = RayTracer::Tuple.vector(1, 0, 0)
    RayTracer::Tuple.magnitude(a).should eq(1)
  end

  # Scenario: Computing the magnitude of vector(0, 1, 0)
  # Given v ← vector(0, 1, 0)
  # Then magnitude(v) = 1
  it "returns the magnitude of a vector with y = 1" do
    a = RayTracer::Tuple.vector(0, 1, 0)
    RayTracer::Tuple.magnitude(a).should eq(1)
  end

  # Scenario: Computing the magnitude of vector(0, 0, 1)
  # Given v ← vector(0, 0, 1)
  # Then magnitude(v) = 1
  it "returns the magnitude of a vector with z = 1" do
    a = RayTracer::Tuple.vector(0, 0, 1)
    RayTracer::Tuple.magnitude(a).should eq(1)
  end

  # Scenario: Computing the magnitude of vector(1, 2, 3)
  # Given v ← vector(1, 2, 3)
  # Then magnitude(v) = √14
  it "returns the magnitude of a vector {1, 2, 3}" do
    a = RayTracer::Tuple.vector(1, 2, 3)
    RayTracer::Tuple.magnitude(a).should eq(Math.sqrt(14))
  end

  it "returns the magnitude of a vector with #magnitude" do
    a = RayTracer::Tuple.vector(1, 2, 3)
    a.magnitude.should eq(Math.sqrt(14))
  end

  # Scenario: Computing the magnitude of vector(-1, -2, -3)
  # Given v ← vector(-1, -2, -3)
  # Then magnitude(v) = √14
  it "returns the magnitude of a vector {-1, -2, -3}" do
    a = RayTracer::Tuple.vector(-1, -2, -3)
    RayTracer::Tuple.magnitude(a).should eq(Math.sqrt(14))
  end

  it "returns the magnitude of a vector with x = 1 " do
    a = RayTracer::Tuple.vector(-1, -2, -3)
    RayTracer::Tuple.magnitude(a).should eq(Math.sqrt(14))
  end

  # Scenario: Normalizing vector(4, 0, 0) gives (1, 0, 0)
  # Given v ← vector(4, 0, 0)
  # Then normalize(v) = vector(1, 0, 0)
  it "returns the normalized vector" do
    a = RayTracer::Tuple.vector(4, 0, 0)
    RayTracer::Tuple.normalize(a).should eq(RayTracer::Tuple.vector(1, 0, 0))
  end

  # Scenario: Normalizing vector(1, 2, 3)
  # Given v ← vector(1, 2, 3)
  # Then normalize(v) = approximately vector(0.26726, 0.53452, 0.80178)
  it "returns the normalized vector for {1, 2, 3}" do
    a = RayTracer::Tuple.vector(1, 2, 3)
    sqrt14 = Math.sqrt(14)
    RayTracer::Tuple.normalize(a).should eq(RayTracer::Tuple.vector(1 / sqrt14, 2 / sqrt14, 3 / sqrt14))
  end

  it "returns the normalized vector for {1, 2, 3} with #normalize" do
    a = RayTracer::Tuple.vector(1, 2, 3)
    sqrt14 = Math.sqrt(14)
    a.normalize.should eq(RayTracer::Tuple.vector(1 / sqrt14, 2 / sqrt14, 3 / sqrt14))
  end

  # Scenario: The magnitude of a normalized vector
  # Given v ← vector(1, 2, 3)
  # When norm ← normalize(v)
  # Then magnitude(norm) = 1
  it "returns the normalized with a magnitude of 1" do
    a = RayTracer::Tuple.vector(1, 2, 3)
    sqrt14 = Math.sqrt(14)
    RayTracer::Tuple.magnitude(RayTracer::Tuple.normalize(a)).should eq(1)
  end

  it "returns the normalized with a magnitude of 1 with #normalize#magnitude" do
    a = RayTracer::Tuple.vector(1, 2, 3)
    sqrt14 = Math.sqrt(14)
    a.normalize.magnitude.should eq(1)
  end

  # Scenario: The dot product of two tuples
  # Given a ← vector(1, 2, 3)
  # And b ← vector(2, 3, 4)
  # Then dot(a, b) = 20
  it "returns the dot product of 2 vectors" do
    a = RayTracer::Tuple.vector(1, 2, 3)
    b = RayTracer::Tuple.vector(2, 3, 4)
    RayTracer::Tuple.dot(a, b).should eq(20)
  end

  it "returns the dot product of 2 vectors with #dot" do
    a = RayTracer::Tuple.vector(1, 2, 3)
    b = RayTracer::Tuple.vector(2, 3, 4)
    a.dot(b).should eq(20)
  end

  # Scenario: The cross product of two vectors
  # Given a ← vector(1, 2, 3)
  # And b ← vector(2, 3, 4)
  # Then cross(a, b) = vector(-1, 2, -1)
  # And cross(b, a) = vector(1, -2, 1)
  it "returns the cross product of 2 vectors" do
    a = RayTracer::Tuple.vector(1, 2, 3)
    b = RayTracer::Tuple.vector(2, 3, 4)
    RayTracer::Tuple.cross(a, b).should eq(RayTracer::Tuple.vector(-1, 2, -1))
    RayTracer::Tuple.cross(b, a).should eq(RayTracer::Tuple.vector(1, -2, 1))
  end

  it "returns the cross product of 2 vectors #cross" do
    a = RayTracer::Tuple.vector(1, 2, 3)
    b = RayTracer::Tuple.vector(2, 3, 4)
    a.cross(b).should eq(RayTracer::Tuple.vector(-1, 2, -1))
    b.cross(a).should eq(RayTracer::Tuple.vector(1, -2, 1))
  end
end
