require 'gosu'

# Reduce Code Length for Parsing (Also move parsing code to another file)
def print_map(map_data)
    columns = map_data['columns']
    notes_data = map_data['notes']
    title = map_data['title']
    artist = map_data['artist']
    creator = map_data['creator']
    version = map_data['version']
    audio_filename = map_data['audio_filename']
    audio_offset = map_data['audio_offset']
    game_mode = map_data['game_mode']
    
    puts("Artist: #{artist}")
    puts("Title: #{title}")
    puts("Creator: #{creator}")
    puts("Version: #{version}")
    puts("Audio Filename: #{audio_filename}")
    puts("Audio Offset: #{audio_offset}")
    puts("Mode: #{game_mode}")
    puts("Columns: #{columns}")
    for note_data in notes_data
        print_note(note_data)
    end
end

def create_note(type, column, start_time, end_time=nil)
    note = {}

    note['type'] = type
    note['column'] = column
    note['start_time'] = start_time
    note['end_time'] = end_time

    return note
end

def print_note(note_data)
    type = note_data['type']
    id = note_data['id']
    column = note_data['column']
    start_time = note_data['start_time']

    if type == "hold"
        end_time = note_data['end_time']
        suffix = ", end_time: #{end_time}ms"
    end
    puts("Note ID is #{id}, type: #{type}, column: #{column}, start_time: #{start_time}ms#{suffix}")
end

def create_map(data, columns=4, title, artist, creator, version, audio_filename, audio_offset, game_mode)
    notes = []

    id = 1
    for note_data in data
        if note_data[1] > columns
            columns = note_data[1]
        end
        if note_data[0] == "hold"
            note = create_note(note_data[0],note_data[1],note_data[2],note_data[3])
        else
            note = create_note(note_data[0],note_data[1],note_data[2])
        end
        note['id'] = id
        notes << note
        id += 1
    end

    map_data = {}

    map_data['notes'] = notes
    map_data['columns'] = columns
    map_data['title'] = title
    map_data['artist'] = artist
    map_data['version'] = version
    map_data['creator'] = creator
    map_data['audio_filename'] = audio_filename
    map_data['audio_offset'] = audio_offset
    map_data['game_mode'] = game_mode

    return map_data
end

def get_key_value_from_file(line)
    setting_data = line.split(":")

    setting_name = setting_data[0].strip
    setting_value = setting_data[1..-1].join(":").strip
    
    return [setting_name, setting_value]
end

def read_map(file_location)
    file = File.new(file_location)

    flag = 0
    data = []
    
    columns = 4 # default columns
    column_width = (512 / columns).floor # maybe no floor
    mode = 3 # mania
    title = ""
    artist = ""
    creator = ""
    version = ""
    audio_filename = ""
    audio_offset = 0

    line = file.gets

    while line != nil
        line = line.chomp
        if line != ""
            if flag == 1
                key_value = get_key_value_from_file(line)
                
                setting_name = key_value[0]
                setting_value = key_value[1]

                if setting_name == "AudioFilename"
                    audio_filename = setting_value
                elsif setting_name == "AudioLeadIn"
                    audio_offset = setting_value
                elsif setting_name == "Mode"
                    game_mode = setting_value
                end
            elsif flag == 2
            elsif flag == 3
                key_value = get_key_value_from_file(line)
                
                setting_name = key_value[0]
                setting_value = key_value[1]

                if setting_name == "Title"
                    title = setting_value
                elsif setting_name == "Artist"
                    artist = setting_value
                elsif setting_name == "Creator"
                    creator = setting_value
                elsif setting_name == "Version"
                    version = setting_value
                end
            elsif flag == 4  # line should be about difficulty settings
                key_value = get_key_value_from_file(line)

                setting_name = key_value[0]
                setting_value = key_value[1]

                if setting_name == "CircleSize"
                    columns = setting_value.to_i # change columns
                    column_width = (512 / columns).floor # recalculate column width
                end
            elsif flag == 5
            elsif flag == 6
            elsif flag == 7
            elsif flag == 8  # line should be note data
                line_data = line.split(",")
                x = line_data[0].to_f
                #y = line_data[1]
                start_time = line_data[2]
                type = line_data[3]
                #hitsound = line_data[4]
                column = ((x / column_width)).floor
                if column >= columns
                    column = columns - 1
                end
                #puts(x,column_width,column)
                if type == "128"
                    line_data_extra = line_data[5].split(":")
                    end_time = line_data_extra[0]
                    type = "hold"
                    #extras = line_data_extra[1..-1]
                    data << [type, column, start_time, end_time]
                elsif type != 8 # do not include 'spinners'
                    type = "tap"
                    data << [type, column, start_time]
                end
            end
            if line == "[General]"
                flag = 1
            elsif line == "[Editor]"
                flag = 2
            elsif line == "[Metadata]"
                flag = 3
            elsif line == "[Difficulty]"
                flag = 4
            elsif line == "[Events]"
                flag = 5
            elsif line == "[TimingPoints]"
                flag = 6
            elsif line == "[Colours]"
                flag = 7
            elsif line == "[Notes]" or line == "[HitObjects]"
                flag = 8
            end
        end
        line = file.gets
    end
    
    map = create_map(data, columns, title, artist, creator, version, audio_filename, audio_offset, game_mode)

    return map
end

map = read_map('sample.rbm')
print_map(map)
