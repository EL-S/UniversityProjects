require './input_functions'

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
	attr_accessor :title, :artist, :genre

# complete the missing code:
	def initialize (title, artist, genre)
    # insert lines here
    @title = title
    @artist = artist
		@genre = genre
	end
end

# Reads in and returns a single album from the given file, with all its tracks
# complete the missing lines
def read_album

  # You could use get_integer_range below to get a genre.
  # You only the need validation if reading from the terminal
  # (i.e when using a file later, you can assume the data in
  # the file is correct)

  # insert lines here - use read_integer_in_range to get a genre
  album_title = read_string("Album Title: ")
  album_artist = read_string("Album Artist: ")
  album_genre = read_integer_in_range("Album ID: ",1,4)
  album = Album.new(album_title, album_artist, album_genre)
end

# Takes a single album and prints it to the terminal
# complete the missing lines:

def print_album album
  puts('Album information is: ')
  # insert lines here
  puts 'Artist is ' + album.title.to_s
  puts 'Album is ' + album.artist.to_s
	puts 'Genre is ' + album.genre.to_s
	puts $genre_names[album.genre]
end

# Reads in an array of albums from a file and then prints all the albums in the
# array to the terminal

def main
	album = read_album()
	print_album(album)
end

main
