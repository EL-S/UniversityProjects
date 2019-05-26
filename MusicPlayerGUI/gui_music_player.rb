require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 750


module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class ArtWork
	attr_accessor :bmp

	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end


# Put your record definitions here


class MusicPlayerMain < Gosu::Window

	def initialize
	    super SCREEN_WIDTH, SCREEN_HEIGHT
	    self.caption = "Music Player"

		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal
	end

  # Put in your code here to load albums and tracks

  # Draws the artwork on the screen for all the albums

  def draw_albums albums
    # complete this code
  end

  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track. returns true or false

  def area_clicked(leftX, topY, rightX, bottomY)
     # complete this code
  end


  # Takes a String title and an Integer ypos
  # You may want to use the following:
  def display_track(title, ypos)
  	@track_font.draw(title, TrackLeftX, ypos, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
  end


  # Takes a track index and an Album and plays the Track from the Album

  def playTrack(track, album)
  	 # complete the missing code
  			@song = Gosu::Song.new(album.tracks[track].location)
  			@song.play(false)
    # Uncomment the following and indent correctly:
  	#	end
  	# end
  end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	def draw_background
		Gosu.draw_rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, BOTTOM_COLOR, ZOrder::BACKGROUND, mode=:default)
	end

# Not used? Everything depends on mouse actions.

	def update
		
	end

 # Draws the album images and the track list for the selected album

	def draw
		# Complete the missing code
		draw_background
		draw_menu
		file = "art/illenium_ashes.jpg"
		draw_artwork(file)
		volume = 70
		draw_volume_level(volume)
	end

	def draw_volume_level(volume)

	end

	def draw_artwork(file)
		@image = Gosu::Image.new(file)
		image_height = @image.height
		image_width = @image.width
		scale = (SCREEN_HEIGHT/image_height.to_f)/2
		spacing_x = (SCREEN_WIDTH-image_width*scale)/2
		spacing_y = (SCREEN_HEIGHT-image_height*scale)/2
		@image.draw(spacing_x, spacing_y, ZOrder::PLAYER, scale, scale)
	end

	def draw_menu
		button_width = SCREEN_WIDTH/12
		button_height = SCREEN_WIDTH/12
		
		button_spacing = button_width/7.5

		total_width = button_width*4 + button_spacing*3
		edge_spacing = (SCREEN_WIDTH-total_width)/2
		
		top_spacing = (SCREEN_HEIGHT-button_height-button_spacing)

		start_x = edge_spacing
		start_y = top_spacing
		end_x = start_x + button_width 
		end_y = start_y + button_height

		inside_spacing = button_width/7.5

		Gosu.draw_rect(start_x, start_y, button_width, button_height, Gosu::Color::BLACK, ZOrder::UI, mode=:default)
		draw_triangle(start_x + inside_spacing, start_y + inside_spacing, Gosu::Color::WHITE, start_x+inside_spacing, end_y - inside_spacing, Gosu::Color::WHITE, end_x - inside_spacing, (start_y+end_y)/2, Gosu::Color::WHITE, ZOrder::UI, mode=:default)

		start_x += button_width + button_spacing
		end_x = start_x + button_width

		Gosu.draw_rect(start_x, start_y, button_width, button_height, Gosu::Color::BLACK, ZOrder::UI, mode=:default)
		Gosu.draw_rect(start_x + inside_spacing, start_y + inside_spacing, button_width-(inside_spacing*2), button_height-(inside_spacing*2), Gosu::Color::WHITE, ZOrder::UI, mode=:default)

		start_x += button_width + button_spacing
		end_x = start_x + button_width

		Gosu.draw_rect(start_x, start_y, button_width, button_height, Gosu::Color::BLACK, ZOrder::UI, mode=:default)
		Gosu.draw_rect(start_x + inside_spacing, start_y + inside_spacing, button_width/4, button_height - (inside_spacing*2), Gosu::Color::WHITE, ZOrder::UI, mode=:default)
		Gosu.draw_rect(end_x - inside_spacing - (button_width/4), start_y + inside_spacing, button_width/4, button_height - (inside_spacing*2), Gosu::Color::WHITE, ZOrder::UI, mode=:default)

		start_x += button_width + button_spacing
		end_x = start_x + button_width

		Gosu.draw_rect(start_x, start_y, button_width, button_height, Gosu::Color::BLACK, ZOrder::UI, mode=:default)
		draw_triangle(start_x + inside_spacing, start_y + inside_spacing, Gosu::Color::WHITE, start_x + inside_spacing, end_y - inside_spacing, Gosu::Color::WHITE, (start_x + end_x)/2, (start_y+end_y)/2, Gosu::Color::WHITE, ZOrder::UI, mode=:default)
		draw_triangle((start_x + end_x)/2, start_y + inside_spacing, Gosu::Color::WHITE, (start_x + end_x)/2, end_y - inside_spacing, Gosu::Color::WHITE, end_x - inside_spacing, (start_y+end_y)/2, Gosu::Color::WHITE, ZOrder::UI, mode=:default)
	end

 	def needs_cursor?; true; end

	# If the button area (rectangle) has been clicked on change the background color
	# also store the mouse_x and mouse_y attributes that we 'inherit' from Gosu
	# you will learn about inheritance in the OOP unit - for now just accept that
	# these are available and filled with the latest x and y locations of the mouse click.

	def button_down(id)
		case id
	    when Gosu::MsLeft
	    	# What should happen here?
	    end
	end

end

# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0
