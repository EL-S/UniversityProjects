require 'gosu'

module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

# Instructions:
# Add a shape_x variable in the following (similar to the cycle one)
# that is initialised to zero then incremented by 10 in update.
# Change the draw method to draw a shape (circle or square)
# (50 pixels in width and height) with a y coordinate of 30
# and an x coordinate of shape_x.
class GameWindow < Gosu::Window

  # initialize creates a window with a width an a height
  # and a caption. It also sets up any variables to be used.
  # This is procedure i.e the return value is 'undefined'
  def initialize
    @@height = 135
    @@width = 200
    super @@width, @@height, false
    self.caption = "Gosu Cycle Example"
    
    # Create and load an image to display
    @background_image = Gosu::Image.new("media/earth.png")

    # Create and load a font for drawing text on the screen
    @font = Gosu::Font.new(20)
    @cycle = 0
    puts "0. In initialize\n"

    # Assign a value to shape_x
    @shape_x = 0
    @flag = true
  end

  # Put any work you want done in update
  # This is a procedure i.e the return value is 'undefined'
  def update
  	puts "1. In update.\n"
    @cycle += 1 # add one to the current value of cycle
    #sleep(0.1)
    if @flag == true && @shape_x < @@width
      @shape_x += 10
      @flag = true
    else
      @flag = false
      if @flag == false && @shape_x > 0
        @shape_x -= 10
        @flag = false
      else
        @shape_x = 10
        @flag = true
      end
    end
  end

  # Draw (or Redraw) the window
  # This is procedure i.e the return value is 'undefined'
  def draw
    # Draws an image with an x, y and z
    #(z determines if it sits on or under other things that are drawn)
    @background_image.draw(0, 0, z = 0)
    @font.draw("Cycle count: #{@cycle}", 10, 10, z = ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    puts "2. In draw\n"
    Gosu.draw_rect(@shape_x, 30, 10, 50, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
  end
end

window = GameWindow.new
window.show
