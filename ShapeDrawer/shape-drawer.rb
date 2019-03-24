require 'rubygems'
require 'gosu'
require './circle'

# The screen has layers: Background, middle, top
module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end
# created a function for selection of areas
# add a drag feature

class DemoWindow < Gosu::Window
  def initialize
    super(3840, 2160, false)
    @old_mouse = [0,0]
    @rectangle_queue = []
    @triangle_queue = []
    @counter = 1
    @mode = 0
    @current_triangle = []
    @current_z = 0
    @colour = Gosu::Color::BLACK
    @colour_str = 'Gosu::Color::BLACK'
    @circle_queue = []
    @radius = 0
    @centre = 0
    @circle_images = []
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    when Gosu::KbR
      @mode = 0
      @counter = 1
      @current_triangle = []
      @new_mouse = []
      @old_mouse = [0,0]
    when Gosu::KbT
      @mode = 1
      @counter = 1
      @current_triangle = []
      @new_mouse = []
      @old_mouse = [0,0]
    when Gosu::KbY
      @mode = 2
      @counter = 1
      @current_triangle = []
      @new_mouse = []
      @old_mouse = [0,0]
    when Gosu::KbQ
      @counter = 1
      @rectangle_queue = []
      @triangle_queue = []
      @current_triangle = []
      @circle_images = []
      @circle_queue = []
      @new_mouse = []
      @old_mouse = [0,0]
    when Gosu::KbW
      @counter = 1
      @current_triangle = []
      @new_mouse = []
      @old_mouse = [0,0]
    when Gosu::KbU
      if @mode == 0
        @rectangle_queue.pop
      elsif @mode == 1
        @triangle_queue.pop
      elsif @mode == 2
        @circle_queue.pop
        @circle_images.pop
      end
      if @current_z > 0
        @current_z -= 1
      end
    when Gosu::KbP
      for rectangle in @rectangle_queue
        x = rectangle[0]
        y = rectangle[1]
        w = rectangle[2]
        h = rectangle[3]
        z_layer = rectangle[4]
        c = rectangle[5]
        c_str = rectangle[6]
        puts("Gosu.draw_rect(#{x}, #{y}, #{w}, #{h}, #{c_str}, #{z_layer}, mode=:default)")
      end
      for triangle in @triangle_queue
        point_1 = triangle[0]
        point_2 = triangle[1]
        point_3 = triangle[2]
        z_layer = triangle[3]
        c = triangle[4]
        c_str = triangle[5]
        puts("draw_triangle(#{point_1[0]}, #{point_1[1]}, #{c_str}, #{point_2[0]}, #{point_2[1]}, #{c_str}, #{point_3[0]}, #{point_3[1]}, #{c_str}, #{z_layer}, mode=:default)")
      end
      i = 0
      for circle in @circle_queue
        x = circle[0]
        y = circle[1]
        r = circle[2]
        z_layer = circle[3]
        c = circle[4]
        c_str = circle[5]
        puts("img_#{i} = Gosu::Image.new(Circle.new(#{r}))")
        puts("img_#{i}.draw(#{x-r}, #{y-r}, #{z_layer}, 1.0, 1.0, #{c_str})")
        i += 1
      end 
    when Gosu::KbZ
      @colour = Gosu::Color::RED
      @colour_str = 'Gosu::Color::RED'
    when Gosu::KbX
      @colour = Gosu::Color::GREEN
      @colour_str = 'Gosu::Color::GREEN'
    when Gosu::KbC
      @colour = Gosu::Color::BLUE
      @colour_str = 'Gosu::Color::BLUE'
    when Gosu::KbV
      @colour = Gosu::Color::WHITE
      @colour_str = 'Gosu::Color::WHITE'
    when Gosu::KbB
      @colour = Gosu::Color::BLACK
      @colour_str = 'Gosu::Color::BLACK'
    when Gosu::KbN
      @colour = Gosu::Color::YELLOW
      @colour_str = 'Gosu::Color::YELLOW'
    when Gosu::KbM
      @colour = Gosu::Color.argb(0xff_472a01)
      @colour_str = 'Gosu::Color.argb(0xff_472a01)'
    when Gosu::MsLeft
      mouse_press(mouse_x, mouse_y)
    end
  end

  def mouse_press(m_x, m_y)
    if @mode == 0
      @new_mouse = [m_x.round,m_y.round]
      width = @new_mouse[0]-@old_mouse[0]
      height = @new_mouse[1]-@old_mouse[1]
      dimensions = [width, height]
      if @counter % 2 == 0
        @rectangle_queue << [@old_mouse[0], @old_mouse[1], width, height, @current_z, @colour, @colour_str]
        @current_z += 1
      end
      @old_mouse = @new_mouse
      @counter += 1
    elsif @mode == 1
      @new_mouse = [m_x.round,m_y.round]
      @current_triangle << @new_mouse
      if @counter % 3 == 0
        @current_triangle << @current_z
        @current_triangle << @colour
        @current_triangle << @colour_str
        @triangle_queue << @current_triangle
        @current_z += 1
        @current_triangle = []
      end
      @old_mouse = @new_mouse
      @counter += 1
    elsif @mode == 2
      @new_mouse = [m_x.round,m_y.round]
      width = @new_mouse[0]-@old_mouse[0]
      height = @new_mouse[1]-@old_mouse[1]
      radius = (((width**2)+(height**2))**(1.0/2)).round
      if @counter % 2 == 0
        @circle_queue << [@old_mouse[0], @old_mouse[1], radius, @current_z, @colour, @colour_str]
        circle_new = Gosu::Image.new(Circle.new(radius, 255, 255, 255))
        @circle_images << circle_new
        @current_z += 1
      end
      @old_mouse = @new_mouse
      @counter += 1
    end
  end

  def needs_cursor?
    true
  end

  def draw
    draw_quad(0, 0, 0xff_ffffff, 3840, 0, 0xff_ffffff, 0, 2610, 0xff_ffffff, 3840, 2160, 0xff_ffffff, ZOrder::BACKGROUND)
    for rectangle in @rectangle_queue
      x = rectangle[0]
      y = rectangle[1]
      w = rectangle[2]
      h = rectangle[3]
      z_layer = rectangle[4]
      c = rectangle[5]
      Gosu.draw_rect(x, y, w, h, c, z_layer, mode=:default)
    end
    for triangle in @triangle_queue
      point_1 = triangle[0]
      point_2 = triangle[1]
      point_3 = triangle[2]
      z_layer = triangle[3]
      c = triangle[4]
      draw_triangle(point_1[0], point_1[1], c, point_2[0], point_2[1], c, point_3[0], point_3[1], c, z_layer, mode=:default)
    end
    i = 0
    for circle in @circle_queue
      x = circle[0]
      y = circle[1]
      r = circle[2]
      z_layer = circle[3]
      c = circle[4]
      @circle_images[i].draw(x-r, y-r, z_layer, 1.0, 1.0, c)
      i += 1
    end
  end
end

DemoWindow.new.show
