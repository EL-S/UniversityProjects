require 'gosu'
require 'time'

class GameWindow < Gosu::Window
  def initialize
    $width = 1920
    $height = 1080
    super $width, $height, :fullscreen => true
    self.caption = "Catch"
    bg_num = rand(1..45).to_s
    puts bg_num
    @background_image = Gosu::Image.new("media/backgrounds/bg"+bg_num+".jpg", :tileable => true)
    @catcher = Catcher.new
    $circle_array = []
    @time_wait = 0.1 #seconds between new circles
    @time_old = Time.new
    $combo = 0
    $notes = { "1" => "A", "2" => "B", "3" => "Bb", "4" => "C#", "5" => "C", "6" => "D", "7" => "E", "8" => "Eb", "9" => "F#", "10" => "F", "11" => "G#", "12" => "G" }
    @font = Gosu::Font.new(self, "Impact", 192)
  end

  def update # refactor and add a menu
    catcher_x, catcher_y = @catcher.get_pos
    for @circle in $circle_array
      @circle.fall
    end
    counter = 0
    temp_array = []
    for @circle in $circle_array
      x, y = @circle.get_pos
      catcher_offset = 153 # to make the catch seem pixel perfect
      catcher_y_offset = catcher_y - catcher_offset
      circle_distance_y = y - catcher_y_offset
      circle_distance_x = (x - catcher_x).abs
      catcher_width = 289 * 0.75 # 0.75 is the catchers scale
      detection_distance = (catcher_width/2)
      if (y > catcher_y_offset) && (circle_distance_y < 30) && (circle_distance_x <= detection_distance) #if the circle is less than 100 pixels from the centre of the catcher
        $combo += 1
        # deletes the circle by omission
        # play a sound corresponding to location
        play_area = $width/2
        section_width = play_area/12
        note_section = ((x - ($width/4)) / section_width).to_s
        note = $notes[note_section]
        if note == nil
          note = 'A'
        end
        puts note
        @note_sample = Gosu::Sample.new("media/sounds/"+note+".ogg")
        @note_sample.play(1, 1, false)
      else
        temp_array << @circle # keep the un caught circle
      end
    end
    $circle_array = temp_array
    @time_new = Time.new
    if (@time_new - @time_old) > @time_wait
      @time_old = Time.new
      $circle_array << Circle.new #generate a new circle, maybe rate limit
    end
    if Gosu::button_down? Gosu::KbLeftShift or Gosu::button_down? Gosu::KbRightShift then
        @modifier = 1.5
    else
        @modifier = 1
    end

    @catcher.image_mode(@modifier)

    if Gosu::button_down? Gosu::KbLeft then
      @catcher.move_left(@modifier)
    end
    if Gosu::button_down? Gosu::KbRight then
      @catcher.move_right(@modifier)
    end
    if $combo != 0

      text_width_black = @font.text_width($combo)
      text_height_black = 192
      text_width_white = @font.text_width($combo)*0.95
      text_height_white = 192*0.95
      @text_offset_black = (catcher_x) - (text_width_black/2)
      @text_offset_white = (catcher_x) - (text_width_white/2)
      @text_offset_white_b = $height/2
      @text_offset_white_v = $height/2 + (text_height_black - text_height_white)/2
    end
  end

  def draw
    for @circle in $circle_array
      @circle.draw
    end
    @catcher.draw
    if $combo != 0
      @font.draw_text($combo, @text_offset_black, @text_offset_white_b, 1, 1, 1, Gosu::Color.argb(0x99_000000))
      @font.draw_text($combo, @text_offset_white, @text_offset_white_v, 2, 0.95, 0.95, Gosu::Color.argb(0xff_ffffff))
    end
    @background_image.draw(0, 0, 0);
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

class Catcher
  def initialize
    @image = Gosu::Image.new("media/catcher.png")
    @x = $width / 2
    @y = $height - 30
    @direction = 0.75
    @base_speed = 20
  end

  def move_left(modifier=1)
    @x -= @base_speed*modifier
    @direction = -0.75 # for changing the image direction
  end

  def move_right(modifier=1)
    @x += @base_speed*modifier
    @direction = 0.75 # for changing the image direction
  end

  def image_mode(modifier)
    if modifier > 1
      @image = Gosu::Image.new("media/catcher_fast.png")
    else
      @image = Gosu::Image.new("media/catcher.png")
    end
  end
  
  def get_pos
    return @x, @y
  end

  def draw
    # Prevent the catcher from moving too close to the edge of the screen
    if @x > $width - ($width*(1.to_f/4))
        @x = $width - ($width*(1.to_f/4))
    elsif @x < $width*(1.to_f/4)
        @x = $width*(1.to_f/4)
    end
    @image.draw_rot(@x.to_i, @y.to_i, 1, 0, 0.5, 0.5, @direction, 0.75)
  end
end

class Circle
  @@x_old = 1920/2
  @@max_distance = 500 # the maximum distance between circles spawning in pixels
  @@min_distance = 0

  def initialize
    @image = Gosu::Image.new("media/circle.png")
    @radius = 40
    @left_limit = ($width*(1.to_f/4) + @radius).to_i
    @right_limit = ($width - ($width*(1.to_f/4)) - @radius).to_i
    while true # get a random x value that is inbounds and not further than the max distance from the last circle
      @x = Random.rand(@left_limit..@right_limit) #random integer in the playing field
      @distance = (@x - @@x_old).abs
      if @distance <= @@max_distance and @distance >= @@min_distance
        @@x_old = @x
        break
      end
    end
    @y = -@radius # negative radius
    # puts @x, @y
  end

  def fall(modifier=1)
    @y += 25
    # Prevent the circle from existing offscreen
    if @y > ($height + @radius)
        # remove the instance and break combo
        $circle_array.delete_at(0) # they all fall at the same rate so the first one should be the lowest
        $combo = 0
    end
  end

  def get_pos
    return @x, @y
  end
  
  def draw
    @image.draw_rot(@x.to_i, @y.to_i, 1, 0)
  end
end

window = GameWindow.new
window.show

puts 'END'
