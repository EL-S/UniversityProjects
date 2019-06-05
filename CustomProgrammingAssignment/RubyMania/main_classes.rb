require 'gosu'
require './file_parser'
require 'time'

# rewrite the parsing to get more information / move file parser to a secondary file
# implement graphics
# also include rubycatch
# volume slider
# background slider
# menu screen

WIDTH = 1920
HEIGHT = 1080

def read_all_maps()
    map_locations = Dir["maps/**/*.rbm"]
    maps = []

    for map_location in map_locations
        map = read_map(map_location)
        maps << map
    end

    return maps
end

class GameWindow < Gosu::Window
  def initialize
    super WIDTH, HEIGHT, :fullscreen => true, :update_interval => 1
    self.caption = "GosuMania"
    @note_x = 0
    @note_y = 0
    load_maps()
    @selected_map = @maps[0]
    @last_frame_time = Time.now
    @song_start_time = Time.now
    @approach_time = 1000.0 # ms
  end

  def update
    @current_frame_time = Time.now
    @time_difference = @current_frame_time - @last_frame_time
    @note_y += (1
    @song_time = Time.now-@song_start_time
    @last_frame_time = @current_frame_time
  end

  def draw
    @columns_width = (WIDTH/3)
    @columns_offset = (WIDTH - @columns_width)/2
    @column_width = @columns_width/@selected_map.columns

    for column in (1..@selected_map.columns+1) do
        @x = @columns_offset+((column-1)*@column_width)
        @y = 0
        Gosu.draw_rect(@x, @y, 1, HEIGHT, Gosu::Color::WHITE)
    end

    Gosu.draw_rect(@columns_offset+((1-1)*@column_width), @note_y, @column_width, 100, Gosu::Color::WHITE)
  end

  def needs_redraw? # if the fps is below  60, skip the frame
    if @time_difference > (1.0/60) # 16.67 ms / 60 fps
        false
    else
        true
    end
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

  def load_maps()
    
    @maps = read_all_maps()

    for map in @maps
        map.print_info
        puts("-"*100)
    end

  end
end

window = GameWindow.new
window.show