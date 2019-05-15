require 'gosu'

class Map
    attr_accessor :map

    def initialize(map, columns=4)
        @map = map
        @columns = columns
    end

    def print_map()
        puts("Map has #{@columns} columns")
        for note in @map
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
            suffix = ", end_time: #{@end_time}"
        end
        puts("Note ID is #{@id}, type: #{@type}, column: #{@column}, start_time: #{@start_time}ms#{suffix}")
    end
end

def create_map(data, columns=4)
    notes = []

    for note_data in data
        if note_data[1] > columns
            columns = note_data[1]
        end
        if note_data[0] == "hold"
            note = Note.new(note_data[0],note_data[1],note_data[2],note_data[3])
        else
            note = Note.new(note_data[0],note_data[1],note_data[2])
        end
        notes << note
    end

    map = Map.new(notes, columns)

    return map
end

def read_map(file_location)
    
    file = File.new(file_location)

    flag = 0
    data = []
    
    columns = 4 # default columns
    column_width = (512 / columns).floor # maybe no floor
    mode = 3 # mania

    line = file.gets

    while line != nil
        line = line.chomp
        if line != ""
            if flag == 1  # line should be note data
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
            elsif flag == 2  # line should be about difficulty settings
                setting_data = line.split(":")
                setting_name = setting_data[0]
                setting_value = setting_data[1]

                if setting_name == "CircleSize"
                    columns = setting_value.to_i # change columns
                    column_width = (512 / columns).floor # recalculate column width
                end
            end
            if line == "[Notes]"
                flag = 1
            elsif line == "[Difficulty]"
                flag = 2
            end
        end
        line = file.gets
    end
    #data = [["hold", 2, 1000, 1100],
    #        ["tap", 3, 1826],
    #        ["tap", 1, 283]
    #    ]

    #columns = 4

    map = create_map(data, columns)

    return map
end

map = read_map('sample.rbm')
map.print_map