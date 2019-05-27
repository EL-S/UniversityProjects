require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)
SCREEN_WIDTH = 1920
SCREEN_HEIGHT = 1080


module ZOrder
  BACKGROUND, PLAYER, UI, UI_TOP = *0..3
end

module Genre
  POP, EDM, FUTUREBASS, RAP = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'EDM', 'Future Bass', 'Rap']

class ArtWork
	attr_accessor :bmp

	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end

# Put your record definitions here

class Album
  attr_accessor :title, :artist, :album_art, :genre, :tracks
  
  def initialize(title, artist, album_art, genre, tracks)
    @title = title
    @artist = artist
		@album_art = album_art
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

class MusicPlayerMain < Gosu::Window

	def initialize
	    super SCREEN_WIDTH, SCREEN_HEIGHT
			self.caption = "Music Player"
			@button_data = []
			@albums = read_albums("albums.txt")
			@font = Gosu::Font.new(25)
			@volume = 100
			@menu = 1
			@album_page = 1
			@current_track = 0
			@stopped = true
			@paused = false
			@display_album_info = false
			@playlist = []
		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal
	end

  # Put in your code here to load albums and tracks
	def read_albums file_name
		
		if File.file?(file_name)
			file = File.new(file_name, "r")
		else
			file = nil
		end
	
		if file
			album_count = file.gets().chomp.to_i
			albums = []
			i = 0
			while i < album_count
				album = read_album(file)
				
				if album != nil
					albums << album
				end
	
				i += 1
			end
			file.close()
		else
			albums = nil
		end
	
		return albums
	end

	def read_album file
		album_artist = file.gets().chomp
		album_title = file.gets().chomp
		album_location = file.gets().chomp
		album_art = ArtWork.new(album_location)
		album_genre = file.gets().to_i
		tracks = read_tracks(file)
		if tracks.length < 15
			album = Album.new(album_title, album_artist, album_art, album_genre, tracks)
		else
			album = Null
			#puts "#{album_title} has more than 15 tracks so it has not been imported."
		end
		album
	end

	# Returns an array of tracks read from the given file
	
	def read_tracks file
		count = file.gets().to_i
		tracks = Array.new
	
		while count > 0
			count -= 1
		
			track = read_track(file)
			tracks << track
		end
		tracks
	end

	def read_track file
		track_name = file.gets().chomp
		file_name = file.gets().chomp
		track = Track.new(track_name, file_name)
		return track
	end

	# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	def draw_background
		Gosu.draw_rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, BOTTOM_COLOR, ZOrder::BACKGROUND, mode=:default)
	end

	def update
		if get_song_status == "song over"
			next_song()
		end
	end

	def get_song_status
		if (Gosu::Song.current_song == nil) and (@stopped == false)
			return "song over"
		elsif (Gosu::Song.current_song == nil)
			return "stopped"
		elsif (@paused)
			return "paused"
		else
			return "playing"
		end
	end

 # Draws the album images and the track list for the selected album

	def draw
		case @menu
			when 1
				draw_background
				draw_page_num()
				draw_album_selection
				draw_forwards_back
				draw_volume_level()
				draw_info(25, 30)
				if @playlist != []
					draw_playlist
					draw_playlist_controls
				end
			when 2
				draw_background
				draw_menu
				draw_back
				draw_artwork()
				draw_info(35, 100)
				draw_genre(25, 150)
				draw_volume_level()
				if @display_album_info
					toggle_album_info
				end
			end
	end

	def draw_back()
		x = 25
		y = 25
		width = 50
		height = 25
		@button_data << ["back", x, y, x+width, y+height]
		Gosu.draw_rect(x, y, width, height, TOP_COLOR, ZOrder::UI, mode=:default)
	end

	def draw_forwards_back()
		if @album_page != @total_pages
			x = SCREEN_WIDTH-75
			y = 25
			width = 50
			height = 25
			@button_data << ["forward", x, y, x+width, y+height]
			Gosu.draw_rect(x, y, width, height, TOP_COLOR, ZOrder::UI, mode=:default)
		end

		if @album_page != 1
			x = 25
			y = 25
			width = 50
			height = 25
			@button_data << ["back", x, y, x+width, y+height]
			Gosu.draw_rect(x, y, width, height, TOP_COLOR, ZOrder::UI, mode=:default)
		end
	end

	def draw_page_num()
		text = "Page #{@album_page}/#{@total_pages}"
		center_text(text, 25, 0xff_000000, SCREEN_WIDTH/2, SCREEN_HEIGHT-50)
	end

	def draw_album_selection()
		@button_data = []

		rows_per_page = 2
		items_per_row = 2

		total_items = @albums.length
		items_per_page = items_per_row*rows_per_page
		@total_pages = (total_items.to_f / items_per_page).ceil

		scale = (SCREEN_HEIGHT/500.to_f)/3
		actual_width = 500*scale

		horizontal_spacing = 4*25
		vertical_spacing = 4*25
		text_vertical_spacing = 25

		row_width = 2*actual_width + horizontal_spacing
		row_height = 2*actual_width + 2*vertical_spacing

		row_offset_horizontal = (SCREEN_WIDTH-row_width)/2
		row_offset_vertical = (SCREEN_HEIGHT-row_height)/2

		start_index = (@album_page-1)*items_per_page
		index = start_index

		current_row = 1

		while index < total_items and index < start_index+(items_per_page)
			image = @albums[index].album_art.bmp
			@button_data << [index, row_offset_horizontal, row_offset_vertical, row_offset_horizontal+actual_width, row_offset_vertical+actual_width]
			image.draw(row_offset_horizontal, row_offset_vertical, ZOrder::PLAYER, scale, scale)
			text = "#{@albums[index].artist} - #{@albums[index].title}"
			@font.draw_text(text, row_offset_horizontal, row_offset_vertical+actual_width+text_vertical_spacing, ZOrder::UI, scale_x = 1, scale_y = 1, color = 0xff_000000)
			index += 1
			row_offset_horizontal += actual_width + horizontal_spacing
			if index == start_index + 2
				row_offset_horizontal = (SCREEN_WIDTH-row_width)/2
				row_offset_vertical += actual_width + vertical_spacing
			end
		end
	end

	def center_text(text, size, color, x_pos, y_pos)
		@text = Gosu::Image.from_text(text, size)
		x = (SCREEN_WIDTH-@text.width)/2 + (x_pos - (SCREEN_WIDTH/2))
		@text.draw(x, y_pos, ZOrder::UI, scale_x = 1, scale_y = 1, color = 0xff_000000)
	end

	def draw_info(size, y)
		if get_song_status == "playing" or get_song_status == "paused"
			begin
				text = "Playing '#{@album.artist}' - '#{@album.tracks[@current_track].name}' from '#{@album.title}'"
				center_text(text, size, 0xff_000000, SCREEN_WIDTH/2, y)
			rescue
			end
		end
	end

	def draw_genre(size, y)
		text = "#{GENRE_NAMES[@album.genre]}"
		center_text(text, size, 0xff_000000, SCREEN_WIDTH/2, y)
	end

	def draw_volume_level()
		volume = @volume
		width = 20
		height = 210
		start_x = SCREEN_WIDTH-width
		start_y = (SCREEN_HEIGHT-height)/2
		spacing = 5
		offset = 5
		volume_scale = (height/100)
		starting_height = start_y+spacing+((100*volume_scale)-volume*volume_scale)
		volume_height = height-(spacing*2)-((100*volume_scale)-volume*volume_scale)
		Gosu.draw_rect(start_x-offset, start_y, width, height, TOP_COLOR, ZOrder::UI, mode=:default)
		Gosu.draw_rect(start_x+spacing-offset, starting_height, width-(spacing*2), volume_height, Gosu::Color::BLACK, ZOrder::UI, mode=:default)
		text = "#{@volume}"
		center_text(text, 20, 0xff_000000, SCREEN_WIDTH-(width/2 + 5), SCREEN_HEIGHT/2 + height/2 + 10)
	end

	def draw_playlist_controls
		button_width = SCREEN_WIDTH/24
		button_height = SCREEN_WIDTH/24
		
		button_spacing = button_width/7.5

		total_width = button_width*4 + button_spacing*3
		edge_spacing = button_spacing
		
		top_spacing = (SCREEN_HEIGHT-button_height-button_spacing)

		start_x = edge_spacing
		start_y = top_spacing
		end_x = start_x + button_width 
		end_y = start_y + button_height

		inside_spacing = button_width/7.5
		
		song_status = get_song_status
		if song_status == "paused" or song_status == "stopped"
			data = draw_play(start_x, start_y, end_y, end_x, top_spacing, edge_spacing, button_spacing, button_width, button_height, inside_spacing)
			start_x = data[0]
			end_x = data[1]
		else
			data = draw_pause(start_x, start_y, end_y, end_x, top_spacing, edge_spacing, button_spacing, button_width, button_height, inside_spacing)
			start_x = data[0]
			end_x = data[1]
		end

		data = draw_stop(start_x, start_y, end_y, end_x, top_spacing, edge_spacing, button_spacing, button_width, button_height, inside_spacing)
		start_x = data[0]
		end_x = data[1]

		data = draw_reverse(start_x, start_y, end_y, end_x, top_spacing, edge_spacing, button_spacing, button_width, button_height, inside_spacing)
		start_x = data[0]
		end_x = data[1]

		data = draw_skip(start_x, start_y, end_y, end_x, top_spacing, edge_spacing, button_spacing, button_width, button_height, inside_spacing)
		start_x = data[0]
		end_x = data[1]
	end

	def draw_artwork()
		image = @image
		image_height = image.height
		image_width = image.width
		@scale = (SCREEN_HEIGHT/image_height.to_f)/2
		spacing_x = (SCREEN_WIDTH-image_width*@scale)/2
		spacing_y = (SCREEN_HEIGHT-image_height*@scale)/2
		@button_data << ["artwork", spacing_x, spacing_y, spacing_x+image_width*@scale, spacing_y+image_height*@scale]
		image.draw(spacing_x, spacing_y, ZOrder::PLAYER, @scale, @scale)
	end

	def draw_play(start_x, start_y, end_y, end_x, top_spacing, edge_spacing, button_spacing, button_width, button_height, inside_spacing)
		@button_data << ["play", start_x, start_y, start_x+button_width, start_y+button_height]
		Gosu.draw_rect(start_x, start_y, button_width, button_height, Gosu::Color::BLACK, ZOrder::UI, mode=:default)
		draw_triangle(start_x + inside_spacing, start_y + inside_spacing, Gosu::Color::WHITE, start_x+inside_spacing, end_y - inside_spacing, Gosu::Color::WHITE, end_x - inside_spacing, (start_y+end_y)/2, Gosu::Color::WHITE, ZOrder::UI, mode=:default)
		start_x += button_width + button_spacing
		end_x = start_x + button_width
		return [start_x, end_x]
	end

	def draw_stop(start_x, start_y, end_y, end_x, top_spacing, edge_spacing, button_spacing, button_width, button_height, inside_spacing)
		@button_data << ["stop", start_x, start_y, start_x+button_width, start_y+button_height]
		Gosu.draw_rect(start_x, start_y, button_width, button_height, Gosu::Color::BLACK, ZOrder::UI, mode=:default)
		Gosu.draw_rect(start_x + inside_spacing, start_y + inside_spacing, button_width-(inside_spacing*2), button_height-(inside_spacing*2), Gosu::Color::WHITE, ZOrder::UI, mode=:default)
		start_x += button_width + button_spacing
		end_x = start_x + button_width
		return [start_x, end_x]
	end

	def draw_pause(start_x, start_y, end_y, end_x, top_spacing, edge_spacing, button_spacing, button_width, button_height, inside_spacing)
		@button_data << ["pause", start_x, start_y, start_x+button_width, start_y+button_height]
		Gosu.draw_rect(start_x, start_y, button_width, button_height, Gosu::Color::BLACK, ZOrder::UI, mode=:default)
		Gosu.draw_rect(start_x + inside_spacing, start_y + inside_spacing, button_width/4, button_height - (inside_spacing*2), Gosu::Color::WHITE, ZOrder::UI, mode=:default)
		Gosu.draw_rect(end_x - inside_spacing - (button_width/4), start_y + inside_spacing, button_width/4, button_height - (inside_spacing*2), Gosu::Color::WHITE, ZOrder::UI, mode=:default)
		start_x += button_width + button_spacing
		end_x = start_x + button_width
		return [start_x, end_x]
	end

	def draw_reverse(start_x, start_y, end_y, end_x, top_spacing, edge_spacing, button_spacing, button_width, button_height, inside_spacing)
		@button_data << ["reverse", start_x, start_y, start_x+button_width, start_y+button_height]
		Gosu.draw_rect(start_x, start_y, button_width, button_height, Gosu::Color::BLACK, ZOrder::UI, mode=:default)
		draw_triangle((start_x + end_x)/2, start_y + inside_spacing, Gosu::Color::WHITE, (start_x + end_x)/2, end_y - inside_spacing, Gosu::Color::WHITE, start_x + inside_spacing, (start_y+end_y)/2, Gosu::Color::WHITE, ZOrder::UI, mode=:default)
		draw_triangle(end_x - inside_spacing, start_y + inside_spacing, Gosu::Color::WHITE, end_x - inside_spacing, end_y - inside_spacing, Gosu::Color::WHITE, (start_x + end_x)/2, (start_y+end_y)/2, Gosu::Color::WHITE, ZOrder::UI, mode=:default)
		start_x += button_width + button_spacing
		end_x = start_x + button_width
		return [start_x, end_x]
	end

	def draw_skip(start_x, start_y, end_y, end_x, top_spacing, edge_spacing, button_spacing, button_width, button_height, inside_spacing)
		@button_data << ["skip", start_x, start_y, start_x+button_width, start_y+button_height]
		Gosu.draw_rect(start_x, start_y, button_width, button_height, Gosu::Color::BLACK, ZOrder::UI, mode=:default)
		draw_triangle(start_x + inside_spacing, start_y + inside_spacing, Gosu::Color::WHITE, start_x + inside_spacing, end_y - inside_spacing, Gosu::Color::WHITE, (start_x + end_x)/2, (start_y+end_y)/2, Gosu::Color::WHITE, ZOrder::UI, mode=:default)
		draw_triangle((start_x + end_x)/2, start_y + inside_spacing, Gosu::Color::WHITE, (start_x + end_x)/2, end_y - inside_spacing, Gosu::Color::WHITE, end_x - inside_spacing, (start_y+end_y)/2, Gosu::Color::WHITE, ZOrder::UI, mode=:default)
		start_x += button_width + button_spacing
		end_x = start_x + button_width
		return [start_x, end_x]
	end

	def draw_menu
		@button_data = []
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
		
		song_status = get_song_status
		if song_status == "paused" or song_status == "stopped"
			data = draw_play(start_x, start_y, end_y, end_x, top_spacing, edge_spacing, button_spacing, button_width, button_height, inside_spacing)
			start_x = data[0]
			end_x = data[1]
		else
			data = draw_pause(start_x, start_y, end_y, end_x, top_spacing, edge_spacing, button_spacing, button_width, button_height, inside_spacing)
			start_x = data[0]
			end_x = data[1]
		end

		data = draw_stop(start_x, start_y, end_y, end_x, top_spacing, edge_spacing, button_spacing, button_width, button_height, inside_spacing)
		start_x = data[0]
		end_x = data[1]

		data = draw_reverse(start_x, start_y, end_y, end_x, top_spacing, edge_spacing, button_spacing, button_width, button_height, inside_spacing)
		start_x = data[0]
		end_x = data[1]

		data = draw_skip(start_x, start_y, end_y, end_x, top_spacing, edge_spacing, button_spacing, button_width, button_height, inside_spacing)
		start_x = data[0]
		end_x = data[1]
	end

	def button_pressed(mouse_x, mouse_y)
		for button in @button_data
			if (mouse_x >= button[1] && mouse_x <= (button[3])) && (mouse_y >= button[2] && mouse_y <= (button[4]))
				return button[0]
			end
		end
		return false
	end

 	def needs_cursor?; true; end

	def play_song()
		@stopped = false
		@paused = false
		@song.play
		@song.volume = (@volume/100.to_f)
	end

	def next_song(direction=1)
		if direction == 1 # next song
			@current_track += 1
			if @current_track >= @album.tracks.length
				@current_track = 0
			end
		else # previous song
			@current_track -= 1
			if @current_track < 0
				@current_track = @album.tracks.length-1
			end
		end
		@song_location = @album.tracks[@current_track].location
		@song = Gosu::Song.new(@song_location)
		@song.play
		@song.volume = (@volume/100.to_f)
	end

	def toggle_album_info
		offset_v = (SCREEN_HEIGHT-(@image.width*@scale))/2
		offset_h = 25
		index = 0
		for track in @album.tracks
			text = track.name
			if index == @current_track
				colour = 0xff_6a7ff7
			else
				colour = 0xff_6ab3f7
			end
			Gosu.draw_rect(0, offset_v, (SCREEN_WIDTH-(@image.width*@scale))/2, 2, Gosu::Color::BLACK, ZOrder::UI_TOP, mode=:default)
			@button_data << [index, 0, offset_v, (SCREEN_WIDTH-(@image.width*@scale))/2, 36+offset_v]
			Gosu.draw_rect(0, offset_v, (SCREEN_WIDTH-(@image.width*@scale))/2, 36, colour, ZOrder::UI, mode=:default)
			@font.draw_text(text, 0+offset_h, 7+offset_v, ZOrder::UI, scale_x = 1, scale_y = 1, color = 0xff_000000)
			offset_v += 36
			index += 1
		end
		if @album.tracks.length < 15
			(15-@album.tracks.length).times do
				Gosu.draw_rect(0, offset_v, (SCREEN_WIDTH-(@image.width*@scale))/2, 2, Gosu::Color::BLACK, ZOrder::UI_TOP, mode=:default)
				Gosu.draw_rect(0, offset_v, (SCREEN_WIDTH-(@image.width*@scale))/2, 36, 0xff_3954bf, ZOrder::UI, mode=:default)
				offset_v += 36
				index += 1
			end
		end
		Gosu.draw_rect(0, offset_v-2, (SCREEN_WIDTH-(@image.width*@scale))/2, 2, Gosu::Color::BLACK, ZOrder::UI_TOP, mode=:default)
	end

	def remove_from_playlist(index)
		element_to_remove = @playlist[index]
		new_playlist = []
		for element in @playlist
			if element != element_to_remove
				new_playlist << element
			end
		end
		@playlist = new_playlist
		create_playlist_album
	end

	def add_to_playlist(track_index, album_index)
		track_data = [track_index, album_index]
		if @playlist.include? track_data # remove it
			new_playlist = []
			for element in @playlist
				if element != track_data
					new_playlist << element
				end
			end
			@playlist = new_playlist
		else
			@playlist << track_data	
		end
	end

	def draw_playlist
		offset_v = (SCREEN_HEIGHT-(500))/2
		offset_h = 25
		index = 0
		width = 450
		for data in @playlist
			@track = @albums[data[1]].tracks[data[0]]
			text = @track.name
			if index == @current_track
				colour = 0xff_6a7ff7
			else
				colour = 0xff_6ab3f7
			end
			Gosu.draw_rect(0, offset_v, width, 2, Gosu::Color::BLACK, ZOrder::UI_TOP, mode=:default)
			@button_data << ["p"+index.to_s, 0, offset_v, (SCREEN_WIDTH-(@image.width*@scale))/2, 36+offset_v]
			Gosu.draw_rect(0, offset_v, width, 36, colour, ZOrder::UI, mode=:default)
			@font.draw_text(text, 0+offset_h, 7+offset_v, ZOrder::UI, scale_x = 1, scale_y = 1, color = 0xff_000000)
			offset_v += 36
			index += 1
		end
		if @playlist.length < 15
			(15-@playlist.length).times do
				Gosu.draw_rect(0, offset_v, width, 2, Gosu::Color::BLACK, ZOrder::UI_TOP, mode=:default)
				Gosu.draw_rect(0, offset_v, width, 36, 0xff_3954bf, ZOrder::UI, mode=:default)
				offset_v += 36
				index += 1
			end
		end
		Gosu.draw_rect(0, offset_v-2, width, 2, Gosu::Color::BLACK, ZOrder::UI_TOP, mode=:default)
	end

	def create_playlist_album
		tracks = []
		for data in @playlist
			tracks << @albums[data[1]].tracks[data[0]]
		end
		@album = Album.new("Various Artists", "Playlist", nil,  0, tracks)
		@current_track = 0
	end

	def button_down(id)
		case id
			when Gosu::MsLeft
				result = button_pressed(mouse_x, mouse_y)
				if result != false
					if @menu == 1
						case result
						when "forward"
							@album_page += 1
						when "back"
							@album_page -= 1
						when "play"
							create_playlist_album
							@song_location = @album.tracks[@current_track].location
							@song = Gosu::Song.new(@song_location)
							play_song()
						when "stop"
							@stopped = true
							@paused = false
							@song.stop
						when "pause"
							@paused = true
							@song.pause
						when "reverse"
							next_song(-1)
						when "skip"
							next_song()
						when "artwork"
							@display_album_info = !@display_album_info
						else
							if result[0] == "p" # it's for the playlist
								result = result.split('p')[1].to_i
								remove_from_playlist(result)
								@song_location = @album.tracks[@current_track].location
								@song = Gosu::Song.new(@song_location)
								play_song()
							else # it's for the album selection
								@album_index = result
								@album = @albums[@album_index]
								@image = @album.album_art.bmp
								@current_track = 0
								@song_location = @album.tracks[@current_track].location
								@song = Gosu::Song.new(@song_location)
								play_song()
								@menu = 2
							end
						end
					elsif @menu == 2
						case result
							when "play"
								play_song()
							when "stop"
								@stopped = true
								@paused = false
								@song.stop
							when "pause"
								@paused = true
								@song.pause
							when "reverse"
								next_song(-1)
							when "skip"
								next_song()
							when "artwork"
								@display_album_info = !@display_album_info
							else
								if @menu == 2
									if result == "back"
										@menu = 1
										create_playlist_album
										if @playlist != []
											@song_location = @album.tracks[@current_track].location
											@song = Gosu::Song.new(@song_location)
											play_song()
										end
									else
										if @current_track != result
											@current_track = result
											@song_location = @album.tracks[@current_track].location
											@song = Gosu::Song.new(@song_location)
											play_song()
										end
										add_to_playlist(@current_track, @album_index)
									end
								end
							end
					end
				end
			when 259
				if @volume < 100
					@volume += 1
				end
				# Volume Up
				if @song != nil
					@song.volume = (@volume/100.to_f)
				end

			when 260
				if @volume > 0
					@volume -= 1
				end
				# Volume Down
				if @song != nil
					@song.volume = (@volume/100.to_f)
				end
	    end
	end

end

# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0
