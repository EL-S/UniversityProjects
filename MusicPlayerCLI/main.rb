
require './input_functions'

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end
  
$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']
  
class Album
  attr_accessor :title, :artist, :genre, :tracks
  
  def initialize(title, artist, genre, tracks)
    @title = title
    @artist = artist
    @genre = genre
    @tracks = tracks
  end
end

class Track
  attr_accessor :name, :location

  def initialize (name, location)
    @name = name
    @location = location
  end
end

# Reads in and returns a single track from the given file

def read_track a_file
  track_name = a_file.gets().chomp
  file_name = a_file.gets().chomp
  track = Track.new(track_name, file_name)
  return track
end

# Returns an array of tracks read from the given file

def read_tracks music_file
  count = music_file.gets().to_i
  tracks = Array.new

  while count > 0
    count -= 1
  
    track = read_track(music_file)
    tracks << track
  end
  tracks
end

# Takes an array of tracks and prints them to the terminal

def print_tracks tracks
  x = 0
  while x < tracks.length
    print_track(tracks[x])
    x += 1
  end
end

def read_albums

  file_name = read_string("Albums Filename: ")
  
  if File.file?(file_name)
    music_file = File.new(file_name, "r")
  else
    music_file = nil
  end

  if music_file
    album_count = music_file.gets().chomp.to_i
    albums = []
    i = 0
    while i < album_count
      album = read_album(music_file)
      
      if album != nil
        albums << album
      end

      i += 1
    end
    music_file.close()
  else
    puts("File Read Error")
    albums = nil
    read_string("Press Enter To Continue...")
  end

  return [albums,file_name]
end

# Reads in and returns a single album from the given file, with all its tracks

def read_album music_file
  album_artist = music_file.gets().chomp
  album_title = music_file.gets().chomp
  album_genre = music_file.gets().to_i
  tracks = read_tracks(music_file)
  if tracks.length < 15
    album = Album.new(album_title, album_artist, album_genre, tracks)
  else
    album = Null
    puts "#{album_title} has more than 15 tracks so it has not been imported."
  end
  album
end


# Takes a single album and prints it to the terminal along with all its tracks

def print_album album
  puts 'Album Artist is ' + album.artist.to_s
  puts 'Album Title is ' + album.title.to_s
  puts 'Genre is ' + album.genre.to_s
  puts $genre_names[album.genre]
  print_tracks(album.tracks)
end

# Takes a single track and prints it to the terminal

def print_track track
  puts('Track title is: ' + track.name)
  puts('Track file location is: ' + track.location)
end


def maintain_albums
  puts 'You selected Enter or Update New Album'
  finished = false
  begin
    puts 'Sub Menu Maintain Albums: Enter your selection:'
    puts '1 To Enter a new Album'
    puts '2 To Update an existing Album'
    puts '3 Return to the Main Menu'
    choice = read_integer_in_range("Please enter your choice:", 1, 3)
    case choice
    when 1
      enter_album
    when 2
      update_existing_album
    when 3
      finished = true
    else
      puts 'Please select again'
    end
  end until finished
end

def display_albums_2(option, albums)
  selected_albums = []
  if option == 0
    for album in albums
      print_album(album)
    end
  elsif option == 1
    genre_id = read_integer_in_range("Select your genre: ",1,4)
    for album in albums
      if album.genre == genre_id
        print_album(album)
        selected_albums << album
      end
    end
  elsif option == 2
    search_title = read_string("Enter your search title: ")
    for album in albums
      if album.title.downcase.chomp == search_title.downcase.chomp
        print_album(album)
        selected_albums << album
      end
    end
  end
  return selected_albums
end

def display_albums(albums, selected_albums)
  puts 'You selected Display Albums'
  finished = false
  begin
    puts 'Sub Menu Display Albums: Enter your selection:'
    puts '1 To Display All Albums'
    puts '2 To Display All Albums of a Specific Genre'
    puts '3 To Display an Album with a specific title'
    puts '4 Return to the Main Menu'
    choice = read_integer_in_range("Please enter your choice:", 1, 4)
    case choice
    when 1
      selected_albums = display_albums_2(0, albums)
    when 2
      selected_albums = display_albums_2(1, albums)
    when 3
      selected_albums = display_albums_2(2, albums)
    when 4
      finished = true
    else
      puts 'Please select again'
    end
  end until finished
  return selected_albums
end

def enter_album
  puts 'You selected Enter a new Album'
  read_string("Press enter to continue")
end

def update_menu_track(track, changed_info)
  finished = false

  begin
    puts 'Update Track Menu:'
    puts '1 Change Track Name'
    puts '2 Change Location'
    puts '3 Exit'
    choice = read_integer_in_range("Please enter your choice:", 1, 3)
    case choice
    when 1
      puts "Current Track Name #{track.name}"
      track.name = read_string("New Track Name: ")
      changed_info = true
    when 2
      puts "Current Location #{track.location}"
      track.location = read_string("New Track Location: ")
      changed_info = true
    when 3
      finished = true
    else
      puts 'Please select again'
    end
  end until finished

  return changed_info
end

def update_menu(album, changed_info)
  finished = false

  begin
    puts 'Update Menu:'
    puts '1 Change Album Artist'
    puts '2 Change Album Title'
    puts '3 Change Track Info'
    puts '4 Exit'
    choice = read_integer_in_range("Please enter your choice:", 1, 4)
    case choice
    when 1
      puts "Current Album Artist #{album.artist}"
      album.artist = read_string("New Album Artist: ")
      changed_info = true
    when 2
      puts "Current Album Title #{album.title}"
      album.title = read_string("New Album Title: ")
      changed_info = true
    when 3
      track = select_track(album)
      changed_info = update_menu_track(track, changed_info)
    when 4
      finished = true
    else
      puts 'Please select again'
    end
  end until finished

  return changed_info
end

def update_album(albums, changed_info)
  puts 'You selected Update an existing Album'
  selected_album = select_album(albums)
  puts "You selected an album to edit it"
  changed_info = update_menu(selected_album, changed_info)
  print_album(selected_album)
  read_string("Press enter to continue")
  return changed_info
end


def select_album(selected_albums)
  puts 'Please select an album below'

  count = selected_albums.length

  i = 0

  while (i < count)
    album = selected_albums[i]
    puts "#{i+1}. #{album.artist} - #{album.title}"
    i += 1
  end
  selected_album_number = read_integer_in_range("Select an Album Number:",1,count)
  selected_album = selected_albums[selected_album_number-1]
  return selected_album
end

def play_album(selected_albums)
  selected_album = select_album(selected_albums)
  selected_track = select_track(selected_album)
  play_track(selected_track)
end

def play_track(selected_track)
  puts "Playing #{selected_track.name}..."
  sleep(3)
  read_string("Press Enter to Stop")
end

def select_track(selected_album)
  puts 'Please select a track below'

  tracks = selected_album.tracks

  count = tracks.length
  i = 0

  while (i < count)
    track = tracks[i]
    puts "#{i+1}. #{track.name}"
    i += 1
  end
  selected_track_number = read_integer_in_range("Select a Track Number:",1,count)
  selected_track = tracks[selected_track_number-1]
  return selected_track
end

def update_file(albums, file_name)
  file = File.new(file_name, "w")

  album_amount = albums.length
  file.puts(album_amount)

  for album in albums
    tracks = album.tracks

    file.puts(album.artist)
    file.puts(album.title)
    file.puts(album.genre)

    track_amount = tracks.length

    file.puts(track_amount)

    for track in tracks
      file.puts(track.name)
      file.puts(track.location)
    end
  end
  file.close
end

def play_menu(selected_albums)
  puts 'Play Album Menu:'
  selected_album = select_album(selected_albums)
  puts 'Play Track Menu:'
  selected_track = select_track(selected_album)
  play_track(selected_track)
end

def main
  finished = false
  changed_info = false

  albums = Array.new

  begin
    puts 'Main Menu:'
    puts '1 Read in Albums'
    puts '2 Display Albums'
    puts '3 Select an Album to Play'
    puts '4 Update an Existing Album'
    puts '5 Exit'
    choice = read_integer_in_range("Please enter your choice:", 1, 5)
    case choice
    when 1
      data_array = read_albums
      albums = data_array[0]
      file_name = data_array[1]
      selected_albums = albums
    when 2
      if selected_albums != nil and selected_albums != []
        selected_albums = display_albums(albums, selected_albums)
      else
        puts("You have no selected albums")
        read_string("Press Enter To Continue...")
      end
    when 3
      if selected_albums != nil and selected_albums != []
        play_menu(selected_albums)
      else
        puts("You have no selected albums")
        read_string("Press Enter To Continue...")
      end
    when 4
      if albums != nil and albums != []
        changed_info = update_album(albums, changed_info)
      else
        puts("You have no albums")
        read_string("Press Enter To Continue...")
      end
    when 5
      puts "Attempting to Exit Program..."
      if changed_info == true
        puts "Updating the album file and then exiting..."
        update_file(albums, file_name)
      end
      read_string("Press Enter To Exit...")
      finished = true
    else
      puts 'Please select again'
    end
  end until finished
end

main
