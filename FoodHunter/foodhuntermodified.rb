# Encoding: UTF-8

require 'rubygems'
require 'gosu'

# Create some constants for the screen SCREEN_WIDTH and SCREEN_HEIGHT
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600


# The following determines which layers things are placed on on the screen
# background is the lowest layer (drawn over by other layers), user interface objects are highest.

module ZOrder
  BACKGROUND, FOOD, PLAYER, UI = *0..3
end

# Note: There is one class for each record in the Ruby Food Hunter Game

class Hunter
  attr_reader :score

  def initialize(hunted)
    @image = Gosu::Image.new("media/Hunter.PNG")
    @yuk = Gosu::Sample.new("media/Yuk.wav")
    @yum = Gosu::Sample.new("media/Yum.wav")

    @hunted = :icecream  # default
    @hunted_image = Gosu::Image.new("media/SmallIcecream.png")

    @vel_x = @vel_y = 3.0
    @x = @y = @angle = 0.0
    @score = 0
  end

  def set_hunted hunted
    @hunted = hunted
    case hunted
    when :chips
      hunted_string = "media/" + "SmallChips.png"
    when :icecream
      hunted_string = "media/" + "SmallIcecream.png"
    when :burger
      hunted_string = "media/" + "SmallBurger.png"
    when :pizza
      hunted_string = "media/" + "SmallPizza.png"
    end
    @hunted_image = Gosu::Image.new(hunted_string)
  end

  def warp(x, y)
    @x, @y = x, y
  end

 def move_left
    @x -= @vel_x
    @x %= SCREEN_WIDTH
  end

  def move_right
    @x += @vel_x
    @x %= SCREEN_WIDTH
  end

  def move_up
    @y -= @vel_y
    @y %= SCREEN_HEIGHT
  end

  def move_down
    @y += @vel_y
    @y %= SCREEN_HEIGHT
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::PLAYER, @angle)
    @hunted_image.draw_rot(@x, @y, ZOrder::PLAYER, @angle)
  end

  def collect_food(all_food)
    all_food.reject! do |food|
      if Gosu.distance(@x, @y, food.x, food.y) < 80 # an arbitrary distance - could be improved!!!
        if (food.type == @hunted)
          @score += 1
          @yum.play
        else
          @score += -1
          @yuk.play
        end
        true
      else
        false
      end
    end
  end
end

class Food

  attr_reader :x, :y, :type

  def initialize(image, type)
    @type = type;
    @image = Gosu::Image.new(image);
    @image_flash = Gosu::Image.new("media/smoke.png");
    @vel_x = rand(-2 .. 2)  # rand(1.2 .. 2.0)
    @vel_y = rand(-2 .. 2)
    @angle = 0.0
    @time_to_flash = nil
    @flash_duration = 1 # 1 second as smoke

  # replace hard coded values with global constants:

    @x = rand * SCREEN_WIDTH
    @y = rand * SCREEN_HEIGHT
    @score = 0
  end

  def move
    @x += @vel_x
    @x %= SCREEN_WIDTH
    @y += @vel_y
    @y %= SCREEN_HEIGHT
  end

  def change_direction
    if rand(2) == 0
      @time_to_flash = Time.now + @flash_duration
      @vel_x = -@vel_x
    end
    if rand(2) == 0
      @time_to_flash = Time.now + @flash_duration
      @vel_y = -@vel_y
    end
  end

  def draw
    if @time_to_flash == nil or @time_to_flash < Time.now
      @image.draw_rot(@x, @y, ZOrder::FOOD, @angle)
      @time_to_flash = nil
    else
      @image_flash.draw_rot(@x, @y, ZOrder::FOOD, @angle)
    end
  end

end

class FoodHunterGame < (Example rescue Gosu::Window)
  def initialize

    # replace hard coded values with global constants:

    super SCREEN_WIDTH, SCREEN_HEIGHT
    self.caption = "Food Hunter Game"

    @background_image = Gosu::Image.new("media/space.png")

    @factor_x = SCREEN_WIDTH/@background_image.width.to_f
    @factor_y = SCREEN_HEIGHT/@background_image.height.to_f

    @food = Array.new

    # Food is created later in generate-food

    @player = Hunter.new(:icecream)

    @player.warp((SCREEN_WIDTH/2).floor, (SCREEN_HEIGHT/2).floor)

    @font = Gosu::Font.new(20)
  end

  def update

    # For key mappings see https://www.libgosu.org/cpp/namespace_gosu.html#enum-members

    if Gosu.button_down? Gosu::KB_LEFT or Gosu.button_down? Gosu::GP_LEFT
      @player.move_left
    end
    if Gosu.button_down? Gosu::KB_RIGHT or Gosu.button_down? Gosu::GP_RIGHT
      @player.move_right
    end
    if Gosu.button_down? Gosu::KB_UP or Gosu.button_down? Gosu::GP_BUTTON_0
      @player.move_up
    end
    if Gosu.button_down? Gosu::KB_DOWN or Gosu.button_down? Gosu::GP_BUTTON_9
      @player.move_down
    end

    @food.each do |food|
      food.move
      if rand(400) == 0
        food.change_direction
      end
    end

    self.remove_food

    @player.collect_food(@food)

    # the following will generate new food randomly as update is called each timestep

   if rand(100) < 2 and @food.size < 4
      @food.push(generate_food)
   end

   # change the hunted food randomly:
   if rand(400) == 0
     change = rand(4)
     case change
      when 0
        @player.set_hunted(:icecream)
      when 1
        @player.set_hunted(:chips)
      when 2
        @player.set_hunted(:burger)
      when 3
        @player.set_hunted(:pizza)
     end
   end
 end

  def draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND, @factor_x, @factor_y)
    @player.draw
    @food.each do |food|
      food.draw
    end
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
  end

  def generate_food
    case rand(4)
    when 0
      Food.new("media/Chips.png", :chips)
    when 1
      Food.new("media/Burger.png", :burger)
    when 2
      Food.new("media/IceCream.png", :icecream)
    when 3
      Food.new("media/Pizza.png", :pizza)
    end
  end

  def remove_food
    @food.reject! do |food|
      # Replace the following hard coded values with global constants:
      if food.x > SCREEN_WIDTH || food.y > SCREEN_HEIGHT || food.x < 0 || food.y < 0
        true
      else
        false
      end
    end
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end
  end
end

FoodHunterGame.new.show if __FILE__ == $0
