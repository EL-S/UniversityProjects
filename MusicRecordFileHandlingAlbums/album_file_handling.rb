
# Task 6.1 T - use the code from last week's tasks to complete this:
# eg: 5.1T, 5.2T

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
# NB: you will need to add tracks to the following and the initialize()
	attr_accessor :title, :artist, :genre, :tracks

# complete the missing code:
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
  # Put a while loop here which increments an index to read the tracks

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


# Reads in and returns a single album from the given file, with all its tracks

def read_album music_file
	album_artist = music_file.gets().chomp
	album_title = music_file.gets().chomp
	album_genre = music_file.gets().to_i
  tracks = read_tracks(music_file)
	album = Album.new(album_title, album_artist, album_genre, tracks)
	album
end


# Takes a single album and prints it to the terminal along with all its tracks
def print_album album

  # print out all the albums fields/attributes
  # Complete the missing code.

	puts 'Genre is ' + album.genre.to_s
	puts $genre_names[album.genre]
	print_tracks(album.tracks)

end

# Takes a single track and prints it to the terminal
def print_track track
  puts('Track title is: ' + track.name)
	puts('Track file location is: ' + track.location)
end

# Reads in an album from a file and then print the album to the terminal

def main
  music_file = File.new("album.txt", "r")
	album = read_album(music_file)
  music_file.close()
	print_album(album)
end

main
