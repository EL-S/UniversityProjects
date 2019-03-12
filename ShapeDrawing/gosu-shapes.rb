require 'rubygems'
require 'gosu'
require './circle'

# The screen has layers: Background, middle, top
module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

class DemoWindow < Gosu::Window
  def initialize
    @width = 640
    @height = 400
    @grid_size = 40 
    super(@width, @height, false)
  end

  def draw
    # see www.rubydoc.info/github/gosu/gosu/Gosu/Color for colours
    draw_quad(0, 0, 0xff_ffffff, 640, 0, 0xff_ffffff, 0, 400, 0xff_ffffff, 640, 400, 0xff_ffffff, ZOrder::BACKGROUND)  # white background rectangle
    #draw_quad(5, 10, Gosu::Color::BLUE, 200, 10, Gosu::Color::AQUA, 5, 150, Gosu::Color::FUCHSIA, 200, 150, Gosu::Color::RED, ZOrder::MIDDLE)  # gradient rectangle 
    #draw_triangle(50, 50, Gosu::Color::GREEN, 100, 50, Gosu::Color::GREEN, 50, 100, Gosu::Color::GREEN, ZOrder::MIDDLE, mode=:default)  # triangle
    for grid_x in (1..@width/@grid_size)
      x1 = grid_x*@grid_size
      y1 = 0
      x2 = grid_x*@grid_size
      y2 = @height
      draw_line(x1, y1, Gosu::Color::BLACK, x2, y2, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)  # black vertical line
    end
    for grid_y in (1..@height/@grid_size)
      x1 = 0
      y1 = grid_y*@grid_size
      x2 = @width
      y2 = grid_y*@grid_size
      draw_line(x1, y1, Gosu::Color::BLACK, x2, y2, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)  # black vertical line
    end
    for grid_x in (1..)
      for grid_y in (1..)
        img = Gosu::Image.new(Circle.new(50, 10, 100, 200), false)
        img.draw 200, 200, ZOrder::TOP
    #draw_line(200, 200, Gosu::Color::BLACK, 350, 350, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)  # black diagonal line
    # draw_rect works a bit differently:
    Gosu.draw_rect(300, 200, 100, 50, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)  # black rectangle
    # Circles are also different - done with a separate gem.
    # first create the circle as a Gosu image then draw it where you want it:
    # the parameters are: radius, red, green, blue
    img = Gosu::Image.new(Circle.new(50, 10, 100, 200), false)
    img.draw 200, 200, ZOrder::TOP
    img = Gosu::Image.new(Circle.new(100, 10, 100, 200), false)
    img.draw 200, 200, ZOrder::TOP
  end
end

DemoWindow.new.show
