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
    for grid_x in (0..(@width/@grid_size)-1)
      for grid_y in (0..(@height/@grid_size)-1)
        img = Gosu::Image.new(Circle.new(20, rand(100..200), rand(100..200), rand(100..200)), false)
        img.draw grid_x*@grid_size, grid_y*@grid_size, ZOrder::TOP
        draw_triangle(grid_x*@grid_size+(@grid_size/3), (grid_y*@grid_size)+((@grid_size*2)/3), Gosu::Color.argb(255, rand(100..200), rand(100..200), rand(100..200)), (grid_x*@grid_size)+((@grid_size*2)/3), (grid_y*@grid_size)+((@grid_size*2)/3), Gosu::Color.argb(255, rand(100..200), rand(100..200), rand(100..200)), (grid_x*@grid_size)+(@grid_size/2),(grid_y*@grid_size)+(@grid_size/3), Gosu::Color.argb(255, rand(100..200), rand(100..200), rand(100..200)), ZOrder::MIDDLE, mode=:default)  # triangle
      end
    end
  end
end

DemoWindow.new.show
