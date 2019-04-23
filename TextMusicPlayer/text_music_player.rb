require './input_functions'

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

# Uh oh - the following is a global variable
# What do we say about using global variables in the lecture notes?
# $genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Track
	attr_accessor :name, :location

	def initialize (name, location)
		@name = name
		@location = location
	end
end

class Album
	attr_accessor :title, :artist, :genre, :tracks

	def initialize (title, artist, genre, tracks)
		@title = title
		@artist = artist
		@genre = genre
		@tracks = tracks
	end
end

# Reads in and returns a single track from the terminal

def read_track
	# Complete the missing code
	track_name = read_string("Track Name:")
	track_location = read_string("Track Location:")
	track = Track.new(track_name, track_location)
	track
end

# Reads in and returns an array of multiple tracks from the given file

def read_tracks
	tracks = Array.new()
	count = read_integer_in_range("Enter track count: ", 0, 15)
	i = 0
	while i < count
		track = read_track()
		tracks << track
		i += 1
	end
	tracks
end

# Display the genre names in a
# numbered list and ask the user to select one
def read_genre()
	genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']
  length = genre_names.length

	i = 1
	while i < length
  	# Complete the missing code
    puts "#{i} " + genre_names[i]
		i += 1
	end
	genre = read_integer_in_range("Enter genre number:", 1, length)
  genre
end

# Reads in and returns a single album from the terminal, with all its tracks

def read_album
	# Complete the missing code
  album_title = read_string("Album Title:")
  album_artist = read_string("Album Artist:")
  album_genre = read_genre() # Genre::POP
  tracks = read_tracks()
	album = Album.new(album_title, album_artist, album_genre, tracks)
	album
end

# Takes an array of tracks and prints them to the terminal

def print_tracks tracks
	count = tracks.length
	i = 0
	while i < count
		print_track(tracks[i])
		i += 1
	end
end

def print_track track
	puts "Track Name: #{track.name}"
	puts "File Location: #{track.location}"
end

# Takes a single album and prints it to the terminal

def print_album album
	# Complete the missing code
	genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']
	puts 'Title is ' + album.title.to_s
	puts 'Artist is ' + album.artist.to_s
	puts 'Genre is ' + album.genre.to_s
	puts genre_names[album.genre]
	print_tracks(album.tracks)
end

# Reads in an array of albums from a file and then prints all the albums in the
# array to the terminal

def main
  puts "Welcome to the music player"
	album = read_album()
	print_album(album)
end

main
