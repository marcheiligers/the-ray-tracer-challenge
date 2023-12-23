require "./spec_helper"

describe RayTracer::Canvas do
  # Scenario: Creating a canvas
  # Given c ← canvas(10, 20)
  # Then c.width = 10
  # And c.height = 20
  # And every pixel of c is color(0, 0, 0)
  it "creates a canvas" do
    c = RayTracer::Canvas.new(10, 20)
    c.width.should eq(10)
    c.height.should eq(20)
    black = RayTracer::Color::BLACK
    10.times do |x|
      20.times do |y|
        c.pixel_at(x, y).should eq(black)
      end
    end
  end

  # Scenario: Writing pixels to a canvas
  # Given c ← canvas(10, 20)
  # And red ← color(1, 0, 0)
  # When write_pixel(c, 2, 3, red)
  # Then pixel_at(c, 2, 3) = red
  it "writes pixels" do
    c = RayTracer::Canvas.new(10, 20)
    red = RayTracer::Color.color(1, 0, 0)
    c.write_pixel(2, 3, red)
    c.pixel_at(2, 3).should eq(red)
  end

  # Scenario: Constructing the PPM header
  # Given c ← canvas(5, 3)
  # When ppm ← canvas_to_ppm(c)
  # Then lines 1-3 of ppm are
  # """
  # P3
  # 5 3
  # 255
  # """
  it "generates a ppm header" do
    expected = <<-EOS.squiggly_heredoc.strip
      P3
      5 3
      255
    EOS
    c = RayTracer::Canvas.new(5, 3)
    c.to_ppm.lines.first(3).join("\n").should eq(expected)
  end

  it "generates a ppm with a default background color" do
    expected = <<-EOS.squiggly_heredoc
      P3
      2 2
      255
      255 255 255 255 255 255
      255 255 255 255 255 255
    EOS
    c = RayTracer::Canvas.new(2, 2, RayTracer::Color::WHITE)
    c.to_ppm.should eq(expected)
  end

  # Scenario: Constructing the PPM pixel data
  # Given c ← canvas(5, 3)
  # And c1 ← color(1.5, 0, 0)
  # And c2 ← color(0, 0.5, 0)
  # And c3 ← color(-0.5, 0, 1)
  # When write_pixel(c, 0, 0, c1)
  # And write_pixel(c, 2, 1, c2)
  # And write_pixel(c, 4, 2, c3)
  # And ppm ← canvas_to_ppm(c)
  # Then lines 4-6 of ppm are """
  #     255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
  #     0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
  #     0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
  #     """
  it "generates ppm pixel data" do
    expected = <<-EOS.squiggly_heredoc.strip
      255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
    EOS
    c = RayTracer::Canvas.new(5, 3)
    c1 = RayTracer::Color.color(1.5, 0, 0)
    c2 = RayTracer::Color.color(0, 0.5, 0)
    c3 = RayTracer::Color.color(-0.5, 0, 1)
    c.write_pixel(0, 0, c1)
    c.write_pixel(2, 1, c2)
    c.write_pixel(4, 2, c3)
    c.to_ppm.lines[3, 3].join("\n").should eq(expected)
  end

  # Scenario: Splitting long lines in PPM files
  # Given c ← canvas(10, 2)
  # When every pixel of c is set to color(1, 0.8, 0.6)
  # And ppm ← canvas_to_ppm(c)
  # Then lines 4-7 of ppm are
  #     """
  #     255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
  #     153 255 204 153 255 204 153 255 204 153 255 204 153
  #     255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
  #     153 255 204 153 255 204 153 255 204 153 255 204 153
  #     """
  it "generates max line length of 70" do
    expected = <<-EOS.squiggly_heredoc.strip
      255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
      153 255 204 153 255 204 153 255 204 153 255 204 153
      255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
      153 255 204 153 255 204 153 255 204 153 255 204 153
    EOS

    c = RayTracer::Canvas.new(10, 2, RayTracer::Color.color(1, 0.8, 0.6))
    c.to_ppm.lines[3, 4].join("\n").should eq(expected)
  end

  # Scenario: PPM files are terminated by a newline character
  # Given c ← canvas(5, 3)
  # When ppm ← canvas_to_ppm(c)
  # Then ppm ends with a newline character
  it "generates a ppm ending in a new line" do
    c = RayTracer::Canvas.new(5, 3)
    c.to_ppm[-1, 1].should eq("\n")
  end
end
