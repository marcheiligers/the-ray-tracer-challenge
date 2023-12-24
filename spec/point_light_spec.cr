require "./spec_helper"

describe RayTracer::PointLight do
  # Scenario: A point light has a position and intensity
  #   Given intensity ← color(1, 1, 1)
  #     And position ← point(0, 0, 0)
  #   When light ← point_light(position, intensity)
  #   Then light.position = position
  #     And light.intensity = intensity
  it "a point light has a position and intensity" do
    intensity = RayTracer::Color.color(1, 1, 1)
    position = RayTracer::Tuple.point(0, 0, 0)
    light = RayTracer::PointLight.new(position, intensity)
    light.position.should eq(position)
    light.intensity.should eq(intensity)
  end
end
