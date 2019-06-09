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
    @hit_height = HEIGHT*0.8
    @note_height = 100

    @approach_time = 400.0 # ms
    @approach_interval = 50.0 # ms to change the approach rate by

    @volume = 100

    #change this to a dictionary for ease of rebinding
    @column_states = {}
    @column_start_taps = {}
    @column_end_taps = {}
    
    @combo = 0

    @draw_volume_time = 0
    @display_combo_until = 0
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

    @selected_map.print_info

    @song_src = @selected_map.source_folder + @selected_map.audio_filename
    @song = Gosu::Song.new(@song_src)
    @wait_time = 2 # wait 2 seconds before starting the song
    @song_start_time = Time.now + @wait_time

    @column_states = {}
    @column_start_taps = {}
    @column_end_taps = {}
    for column_number in (0..@selected_map.columns-1)
        @column_states[column_number] = false
        @column_start_taps[column_number] = nil
        @column_end_taps[column_number] = nil
    end

    @notes_all = @selected_map.notes
    @notes = []
    @note_index = 0
    @flag = true

  end

  def update_song

    if Time.now > @song_start_time and @flag == true

        @song.play
        @song.volume = (@volume/100.to_f)

        @flag = false
    end

    if get_song_status == "playing" or get_song_status == "song_over" # song_over is important as the song might require notes fall before it starts
        @song_time = Time.now-@song_start_time
    end
  end

  def get_song_status()
    @song_object = Gosu::Song.current_song
    if @song_object == nil
        #song stopped or over or hasn't started yet
        return "song_over"
    else
        if @song_object.playing?
            return "playing"
        else
            return "paused"
        end
    end
  end

  def note_fall

    @note_positions = {}

    for note in @notes
        @note_hit_time = note.start_time
        @note_start_time = @note_hit_time.to_i - @approach_time
        @note_y = (@hit_height/@approach_time)*((@song_time*1000)-@note_start_time)-@note_height
        @note_positions[note.id] = @note_y
    end
  end

  def note_delete

    @note_positions.each do | note_id, position |

        if position > HEIGHT # if the note is off the screen,
            @note_positions.delete(note_id)
            note_value = ""
            for note in @notes
                if note.id == note_id
                    note_value = note
                    @combo = 0 # the note was missed by the player
                    @display_combo_until = Time.now + 2
                    break
                end
            end

            @notes.delete(note_value)
        end
    end
  end

  def delete_specific_note(note)
    @notes.delete(note)
  end

  def center_text(text, size, color, x_pos, y_pos)
    @text = Gosu::Image.from_text(text, size)
    x = (WIDTH-@text.width)/2 + (x_pos - (WIDTH/2))
    @text.draw(x, y_pos, 3, scale_x = 1, scale_y = 1, color)
  end

  def note_tap()
    @column_states.each do |column, state|
        if state # button is currently held
            # use the song time to determine whether there is a note within some ms before or after the tap time
            for note in @notes
                start_tap = @column_start_taps[column]
                if start_tap != nil
                    timing = (start_tap*1000 - note.start_time.to_i)
                    if note.column == column and timing.abs <= 150
                        @column_start_taps[column] = nil
                        #puts("#{note.id}, #{timing}")
                        @combo += 1
                        @display_combo_until = Time.now + 2
                        delete_specific_note(note)
                        break
                    end
                else
                    break
                end
            end
        end
    end
  end

  def update
    # condition to determine options, paused, song_select or gameplay

    update_song() # move this to the song_select button event

    # time between frames, used to skip frames
    @current_frame_time = Time.now
    @time_difference = @current_frame_time - @last_frame_time
    
    
    # load the next chunk of visible notes into the notes array
    get_next_note_group()

    # calculate note position below
    note_fall()
    
    # remove old notes from the array
    note_delete()
    
    # tap notes
    if get_song_status == "playing"
        note_tap()
    end
    # set the last frame to the frame just used
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

        @note_y_pos = @note_positions[note.id]

        Gosu.draw_rect(@columns_offset+((column_number)*@column_width), @note_y_pos, @column_width, @note_height, Gosu::Color::WHITE)
    end

    @column_states.each do |column, state|
        if state
            Gosu.draw_rect(@columns_offset+((column)*@column_width), @hit_height, @column_width, (HEIGHT-@hit_height)/4, Gosu::Color::AQUA)
        end
    end

    Gosu.draw_rect(@columns_offset, @hit_height, @columns_width, 1, Gosu::Color::RED)

    if @draw_volume_time != 0
        if Time.now < @draw_volume_time
            draw_volume_level()
        end
    end

    # draw combo, also draw total accuracy and note accuracy
    if @display_combo_until != 0 
        if Time.now < @display_combo_until
            center_text(@combo.to_s, 200, Gosu::Color::WHITE, WIDTH/2, 300)
        end
    end
  end

  def draw_volume_level() #refactor
    volume = @volume
    width = 20
    height = 210
    start_x = WIDTH-width
    start_y = (HEIGHT-height)/2
    spacing = 5
    offset = 5
    volume_scale = (height/100)
    starting_height = start_y+spacing+((100*volume_scale)-volume*volume_scale)
    volume_height = height-(spacing*2)-((100*volume_scale)-volume*volume_scale)
    Gosu.draw_rect(start_x-offset, start_y, width, height, Gosu::Color::WHITE, 1, mode=:default)
    Gosu.draw_rect(start_x+spacing-offset, starting_height, width-(spacing*2), volume_height, Gosu::Color::BLACK, 1, mode=:default)
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
        status = get_song_status()
        if status == "playing"
            @time_paused_start = Time.now
            @song.pause
        elsif status == "paused"
            @time_paused_end = Time.now
            @time_paused = @time_paused_end - @time_paused_start
            @song_start_time += @time_paused # so the notes are in the correct time position
            @song.play
            @song.volume = (@volume/100.to_f)
        else
            close
        end
    elsif id == Gosu::KB_Q
        @column_states[0] = true
        if @column_start_taps[0] == nil # prevent holding to tap
            @column_start_taps[0] = @song_time
            @column_end_taps[0] = nil
        end
    elsif id == Gosu::KB_W
        @column_states[1] = true
        if @column_start_taps[1] == nil # prevent holding to tap
            @column_start_taps[1] = @song_time
            @column_end_taps[1] = nil
        end
    elsif id == Gosu::KbDelete
        @column_states[2] = true
        if @column_start_taps[2] == nil # prevent holding to tap
            @column_start_taps[2] = @song_time
            @column_end_taps[2] = nil
        end
    elsif id == Gosu::KbEnd
        @column_states[3] = true
        if @column_start_taps[3] == nil # prevent holding to tap
            @column_start_taps[3] = @song_time
            @column_end_taps[3] = nil
        end
    elsif id == 259
        if @volume < 100
            @volume += 1
        end
        # Volume Up
        if @song != nil
            @song.volume = (@volume/100.to_f)
        end
        @draw_volume_time = Time.now + 1
    elsif id == 260
        if @volume > 0
            @volume -= 1
        end
        # Volume Down
        if @song != nil
            @song.volume = (@volume/100.to_f)
        end
        @draw_volume_time = Time.now + 1
    end
  end

  def change_approach_time(change)
    if change == 1 # increase the approach time (eg. slower notes)
        @approach_time += @approach_interval
    elsif change == -1 # decrease the approach time (eg. faster notes)
        @approach_time -= @approach_interval

        if @approach_time < @approach_interval
            @approach_time = @approach_interval
        end
    end
  end

  def button_up(id)
    if id == Gosu::KB_Q
        @column_states[0] = false
        @column_start_taps[0] = nil
        @column_end_taps[0] = @song_time
    elsif id == Gosu::KB_W
        @column_states[1] = false
        @column_start_taps[1] = nil
        @column_end_taps[1] = @song_time
    elsif id == Gosu::KbDelete
        @column_states[2] = false
        @column_start_taps[2] = nil
        @column_end_taps[2] = @song_time
    elsif id == Gosu::KbEnd
        @column_states[3] = false
        @column_start_taps[3] = nil
        @column_end_taps[3] = @song_time
    elsif id == Gosu::KB_F3
        change_approach_time(1)
    elsif id == Gosu::KB_F4
        change_approach_time(-1)
    end
  end

  def load_maps()
    
    @maps = read_all_maps()

    #for map in @maps
    #    map.print_info
    #    puts("-"*100)
    #end

  end
end

window = GameWindow.new
window.show