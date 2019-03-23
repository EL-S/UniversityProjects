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
        #puts("draw_triangle(#{point_1[0]}, #{point_1[1]}, #{c}, #{point_2[0]}, #{point_2[1]}, #{c}, #{point_3[0]}, #{point_3[1]}, #{c}, #{z_layer}, mode=:default)")
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
      if @mode == 0
        @new_mouse = [mouse_x.round,mouse_y.round]
        #puts("new_x_y #{@new_mouse}")
        width = @new_mouse[0]-@old_mouse[0]
        height = @new_mouse[1]-@old_mouse[1]
        dimensions = [width, height]
        #puts("old_x_y #{@old_mouse}")
        if @counter % 2 == 0
          #puts("Gosu.draw_rect(#{@old_mouse[0]}, #{@old_mouse[1]}, #{width}, #{height}, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)")
          @rectangle_queue.append([@old_mouse[0], @old_mouse[1], width, height, @current_z, @colour, @colour_str])
          @current_z += 1
        end
        #puts("Dimensions #{dimensions}")
        #@rectangle_queue.append([@old_mouse[0], @old_mouse[1], width, height])
        @old_mouse = @new_mouse
        @counter += 1
      elsif @mode == 1
        @new_mouse = [mouse_x.round,mouse_y.round]
        @current_triangle.append(@new_mouse)
        if @counter % 3 == 0
          #puts("draw_triangle(#{@current_triangle[0][0]}, #{@current_triangle[0][1]}, Gosu::Color::GREEN, #{@current_triangle[1][0]}, #{@current_triangle[1][1]}, Gosu::Color::GREEN, #{@current_triangle[2][0]}, #{@current_triangle[2][1]}, Gosu::Color::GREEN, ZOrder::MIDDLE, mode=:default)")
          @current_triangle.append(@current_z)
          @current_triangle.append(@colour)
          @current_triangle.append(@colour_str)
          @triangle_queue.append(@current_triangle)
          @current_z += 1
          @current_triangle = []
        end
        #puts("Dimensions #{dimensions}")
        #@rectangle_queue.append([@old_mouse[0], @old_mouse[1], width, height])
        @old_mouse = @new_mouse
        @counter += 1
      elsif @mode == 2
        @new_mouse = [mouse_x.round,mouse_y.round]
        #puts("new_x_y #{@new_mouse}")
        width = @new_mouse[0]-@old_mouse[0]
        height = @new_mouse[1]-@old_mouse[1]
        radius = (((width**2)+(height**2))**(1.0/2)).round
        #puts("old_x_y #{@old_mouse}")
        if @counter % 2 == 0
          #puts("Gosu.draw_rect(#{@old_mouse[0]}, #{@old_mouse[1]}, #{width}, #{height}, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)")
          @circle_queue.append([@old_mouse[0], @old_mouse[1], radius, @current_z, @colour, @colour_str])
          circle_new = Gosu::Image.new(Circle.new(radius))
          @circle_images.append(circle_new)
          @current_z += 1
        end
        #puts("Dimensions #{dimensions}")
        #@rectangle_queue.append([@old_mouse[0], @old_mouse[1], width, height])
        @old_mouse = @new_mouse
        @counter += 1
      end
    end
  end

  def needs_cursor?
    true
  end

  def draw
    # see www.rubydoc.info/github/gosu/gosu/Gosu/Color for colours
    draw_quad(0, 0, 0xff_ffffff, 3840, 0, 0xff_ffffff, 0, 2610, 0xff_ffffff, 3840, 2160, 0xff_ffffff, ZOrder::BACKGROUND)
    #draw_quad(5, 10, Gosu::Color::BLUE, 200, 10, Gosu::Color::AQUA, 5, 150 Gosu::Color::FUCHSIA, 200, 150, Gosu::Color::RED, ZOrder::MIDDLE)
    #draw_triangle(50, 50, Gosu::Color::GREEN, 100, 50, Gosu::Color::GREEN, 50, 100, Gosu::Color::GREEN, ZOrder::MIDDLE, mode=:default)
    #draw_line(200, 200, Gosu::Color::BLACK, 350, 350, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
    # draw_rect works a bit differently:
    #Gosu.draw_rect(300, 200, 100, 50, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
   
   
    # Circle parameter - Radius
    #img2 = Gosu::Image.new(Circle.new(50))
    # Image draw parameters - x, y, z, horizontal scale (use for ovals), vertical scale (use for ovals), colour
    # Colour - use Gosu::Image::{Colour name} or .rgb({red},{green},{blue}) or .rgba({alpha}{red},{green},{blue},)
    # Note - alpha is used for transparency.
    # drawn as an elipse (0.5 width:)
    #img2.draw(200, 200, ZOrder::TOP, 0.5, 1.0, Gosu::Color::BLUE)
    # drawn as a red circle:
    #img2.draw(300, 50, ZOrder::TOP, 1.0, 1.0, 0xff_ff0000)
    # drawn as a red circle with transparency:
    #img2.draw(300, 250, ZOrder::TOP, 1.0, 1.0, 0x64_ff0000)
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
