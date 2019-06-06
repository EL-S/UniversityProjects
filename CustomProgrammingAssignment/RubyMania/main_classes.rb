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
    load_maps()
    initiate_song(rand(0..@maps.length-1))
    @last_frame_time = Time.now
    @hit_height = HEIGHT*0.9
    @note_height = 100

    @approach_time = 400.0 # ms

    @column_1 = false
    @column_2 = false
    @column_3 = false
    @column_4 = false
    

  end

  def get_next_note_group()

    #add notes to current notes that are happening in less than the approach time

    count = @notes_all.length

    while @note_index < count
        note = @notes_all[@note_index]

        @note_start_time = note.start_time.to_i - @approach_time

        break if @note_start_time > (@song_time*1000 + @approach_time) # if the note doesn't need to exist yet, leave the while loop

        @notes << note # the note needs to exist now

        @note_index += 1
    end

  end

  def initiate_song(map_id) # call when a song is selected
    
    @selected_map = @maps[map_id]
    @song_src = @selected_map.source_folder + @selected_map.audio_filename
    @song = Gosu::Song.new(@song_src)
    @wait_time = Time.now + 2 #wait 2 seconds before starting the song

    @notes_all = @selected_map.notes
    @notes = []
    @note_index = 0
    @flag = true

  end

  def update_song

    @song_start_time = @wait_time

    if Time.now > @wait_time and @flag == true

        @song.play

        @flag = false
    end

    # handle song pause here and time based pause events
  end

  def note_fall

    @note_positions = []

    for note in @notes
        @note_hit_time = note.start_time
        @note_start_time = @note_hit_time.to_i - @approach_time
        @note_y = (@hit_height/@approach_time)*((@song_time*1000)-@note_start_time)-@note_height
        @note_positions << @note_y
    end
  end

  def note_delete
    delete_index = 0
    count = @note_positions.length
    while delete_index < count

        break if @note_positions[delete_index] < HEIGHT # if the note is still on the screen, break

        delete_index += 1 # the note does not need to exist now, we keep note how many we need to remove based on the index
    end

    if delete_index > 0
        @notes = @notes[delete_index..-1] #remove the note
        @note_positions = @note_positions[delete_index..-1] #remove the note
    end
  end

  def update
    #condition to determine options, paused, song_select or gameplay

    update_song() #move this to the song_select button event

    # time between frames, used to skip frames
    @current_frame_time = Time.now
    @time_difference = @current_frame_time - @last_frame_time
    @song_time = Time.now-@song_start_time
    
    #load the next chunk of visible notes into the notes array
    get_next_note_group()

    # calculate note position below
    note_fall()
    
    #remove old notes from the array
    note_delete()
    
    #set the last frame to the frame just used
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

    @notes.each_with_index do |note, index|
        column_number = note.column

        @note_y_pos = @note_positions[index]

        Gosu.draw_rect(@columns_offset+((column_number)*@column_width), @note_y_pos, @column_width, @note_height, Gosu::Color::WHITE)
    end

    if @column_1
        Gosu.draw_rect(@columns_offset+((0)*@column_width), @hit_height, @column_width, HEIGHT-@hit_height, Gosu::Color::AQUA)
    end
    if @column_2
        Gosu.draw_rect(@columns_offset+((1)*@column_width), @hit_height, @column_width, HEIGHT-@hit_height, Gosu::Color::AQUA)
    end
    if @column_3
        Gosu.draw_rect(@columns_offset+((2)*@column_width), @hit_height, @column_width, HEIGHT-@hit_height, Gosu::Color::AQUA)
    end
    if @column_4
        Gosu.draw_rect(@columns_offset+((3)*@column_width), @hit_height, @column_width, HEIGHT-@hit_height, Gosu::Color::AQUA)
    end

    Gosu.draw_rect(@columns_offset, @hit_height, @columns_width, 1, Gosu::Color::RED)
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
        close # pause instead
    elsif id == Gosu::KB_Q
        @column_1 = true
    elsif id == Gosu::KB_W
        @column_2 = true
    elsif id == Gosu::KbDelete
        @column_3 = true
    elsif id == Gosu::KbEnd
        @column_4 = true
    end
  end

  def button_up(id)
    if id == Gosu::KB_Q
        @column_1 = false
    elsif id == Gosu::KB_W
        @column_2 = false
    elsif id == Gosu::KbDelete
        @column_3 = false
    elsif id == Gosu::KbEnd
        @column_4 = false
    elsif id == Gosu::KB_F3
        @approach_time += 100
    elsif id == Gosu::KB_F4
        @approach_time -= 100

        if @approach_time < 100
            @approach_time = 100
        end
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