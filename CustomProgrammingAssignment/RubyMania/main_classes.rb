require 'gosu'

# rewrite the parsing to get more information
# implement graphics
# also include rubycatch
# volume slider
# background slider
# menu screen

class Map
    attr_accessor :notes, :columns, :title, :artist, :creator, :version, :audio_filename, :audio_offset, :game_mode

    def initialize(notes, columns, title, artist, creator, version, audio_filename, audio_offset, game_mode)
        @columns = columns
		@notes = notes
		@title = title
		@artist = artist
		@creator = creator
		@version = version
		@audio_filename = audio_filename
		@audio_offset = audio_offset
		@game_mode = game_mode
    end

    def print_map()
        puts("Artist: #{@artist}")
		puts("Title: #{@title}")
		puts("Creator: #{@creator}")
		puts("Version: #{@version}")
		puts("Audio Filename: #{@audio_filename}")
		puts("Audio Offset: #{@audio_offset}ms")
		puts("Mode: #{@game_mode}")
		puts("Columns: #{@columns}")
		puts("Notes: #{@notes.length}")
        for note in @notes
            note.print_data()
        end
    end
end

class Note
    attr_accessor :type, :column, :start_time, :end_time
    @@id = 1

    def initialize(type, column, start_time, end_time=nil)
        @id = @@id
        @type = type
        @column = column
        @start_time = start_time
        @end_time = end_time
        @@id += 1
    end

    def print_data()
        if @type == "hold"
            suffix = ", end_time: #{@end_time}ms"
        end
        puts("Note ID is #{@id}, type: #{@type}, column: #{@column}, start_time: #{@start_time}ms#{suffix}")
    end
end

def create_map(data)
    
	notes_data = data['notes_data']
	columns = data['columns']
    column_width = data['column_width']
    game_mode = data['game_mode']
    title = data['title']
    artist = data['artist']
    creator = data['creator']
    version = data['version']
    audio_filename = data['audio_filename']
    audio_offset = data['audio_offset']
	
	notes = []

    for note_data in notes_data
        if note_data[1] > columns #note exists in a column that doesn't exist, changing column number to reflect that.
            columns = note_data[1]
        end
        if note_data[0] == "hold" # a hold not with an end time
            note = Note.new(note_data[0],note_data[1],note_data[2],note_data[3])
        else #a tap note
            note = Note.new(note_data[0],note_data[1],note_data[2])
        end
        notes << note
    end

    map = Map.new(notes, columns, title, artist, creator, version, audio_filename, audio_offset, game_mode)

    return map
end

def get_key_value_from_line(line)
    setting_data = line.split(":")

    setting_name = setting_data[0].strip
    setting_value = setting_data[1..-1].join(":").strip
    
    return [setting_name, setting_value]
end

def process_line(data, line, flag) # refactor this because it is not nice, maybe have a function for each flag with an appropriate name
	line = line.chomp
	if line != ""
		if flag == 1
			key_value = get_key_value_from_line(line)
			
			setting_name = key_value[0]
			setting_value = key_value[1]

			if setting_name == "AudioFilename"
				data['audio_filename'] = setting_value
			elsif setting_name == "AudioLeadIn"
				data['audio_offset'] = setting_value
			elsif setting_name == "Mode"
				data['game_mode'] = setting_value
			end
		elsif flag == 2
		elsif flag == 3
			key_value = get_key_value_from_line(line)
			
			setting_name = key_value[0]
			setting_value = key_value[1]

			if setting_name == "Title"
				data['title'] = setting_value
			elsif setting_name == "Artist"
				data['artist'] = setting_value
			elsif setting_name == "Creator"
				data['creator'] = setting_value
			elsif setting_name == "Version"
				data['version'] = setting_value
			end
		elsif flag == 4  # line should be about difficulty settings
			key_value = get_key_value_from_line(line)

			setting_name = key_value[0]
			setting_value = key_value[1]

			if setting_name == "CircleSize"
				data['columns'] = setting_value.to_i # change columns
				data['column_width'] = (512 / data['columns']).floor # recalculate column width
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
			column = ((x / data['column_width'])).floor
			if column >= data['columns']
				column = data['columns'] - 1
			end
			#puts(x,column_width,column)
			if type == "128"
				line_data_extra = line_data[5].split(":")
				end_time = line_data_extra[0]
				type = "hold"
				#extras = line_data_extra[1..-1]
				data['notes_data'] << [type, column, start_time, end_time]
			elsif type != 8 # do not include 'spinners'
				type = "tap"
				data['notes_data'] << [type, column, start_time]
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

	return [data, flag]
end

def read_map(file_location)
    file = File.new(file_location)
    
    columns = 4 # default columns
    column_width = (512 / columns).floor # maybe no floor
	
	data = {"notes_data" => [], "columns" => 4, "column_width" => column_width, "game_mode" => 3, "title" => "", "artist" => "", "creator" => "", "version" => "", "audio_filename" => "", "audio_offset" => ""}
	
    flag = 0
	
	File.foreach(file) do |line|
		data_from_line = process_line(data, line, flag)
		data = data_from_line[0]
		flag = data_from_line[1]
    end

    map = create_map(data)

    return map
end

map = read_map('sample.rbm')
map.print_map
