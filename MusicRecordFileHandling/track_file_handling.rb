
# Look at Task 5.1 T Music Records for an example of how to create the following

class Track
  attr_accessor :title, :file_location
  
	def initialize (title, file_location)
    @title = title
    @file_location = file_location
	end
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

# reads in a single track from the given file.
def read_track a_file
  title = a_file.gets().chomp
  file_location = a_file.gets().chomp
  track = Track.new(title, file_location)
  return track
  # complete this function
	# you need to create a Track here - see 5.1 T, Music Record for this too.
end


# Takes an array of tracks and prints them to the terminal
def print_tracks tracks
  i = 0
  while i < tracks.length
    print_track(tracks[i])
	i += 1
  end
  # Use a while loop with a control variable index
  # to print each track. Use tracks.length to determine how
  # many times to loop.

  # Print each track use: tracks[index] to get each track record
end

# Takes a single track and prints it to the terminal
def print_track track
  puts('Track title is: ' + track.title)
  puts('Track file location is: ' + track.file_location)
end

# Open the file and read in the tracks then print them
def main
  a_file = File.new("input.txt", "r") # open for reading
  if a_file  # if nil this test will be false
    tracks = read_tracks(a_file)
    a_file.close
  else
    puts "Unable to open file to read!"
  end
  # Print all the tracks
  print_tracks(tracks)
end

main
