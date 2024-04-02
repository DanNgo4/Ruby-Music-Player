require 'rubygems'
require 'gosu'
require './music_player'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)
WIDTH = 1400
HEIGHT = 650
TrackLeftX = 650

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

class ArtWork
	attr_accessor :bmp
	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end

class MusicPlayerMain < Gosu::Window
	def initialize
	    super WIDTH, HEIGHT
	    self.caption = "GUI Music Player"
		@track_font = Gosu::Font.new(40)
		@pause_status = "images/pause.png"
		@selected_album = nil
		@picked_tracks = nil
	end

  def draw_buttons()
	draw_line(640, 500, Gosu::Color::BLACK, 1000, 500, Gosu::Color::BLACK, ZOrder::BACKGROUND, mode=:default)
	ArtWork.new("images/mute.png").bmp.draw(660, 510, ZOrder::PLAYER)
	ArtWork.new("images/down.png").bmp.draw(700, 510, ZOrder::PLAYER)
	ArtWork.new("images/previous.png").bmp.draw(735, 500, ZOrder::PLAYER)
	ArtWork.new(@pause_status).bmp.draw(778, 500, ZOrder::PLAYER)
	ArtWork.new("images/next.png").bmp.draw(830, 510, ZOrder::PLAYER)
	ArtWork.new("images/up.png").bmp.draw(872, 510, ZOrder::PLAYER)
	ArtWork.new("images/replay.png").bmp.draw(914, 512, ZOrder::PLAYER)
  end
  # Draw the artwork on the screen for all the albums
  def draw_albums()
	music_file = File.new('albums.txt', "r")
	albums = read_albums(music_file)
	music_file.close()
	ArtWork.new(albums[0].image).bmp.draw(10, 10, ZOrder::UI)
	ArtWork.new(albums[1].image).bmp.draw(10, 320, ZOrder::UI)
	ArtWork.new(albums[2].image).bmp.draw(320, 10, ZOrder::UI)
	ArtWork.new(albums[3].image).bmp.draw(320, 320, ZOrder::UI)
	# Highlight the selected album
	if (@selected_album == 1 or ((mouse_x > 10 and mouse_x < 310) and (mouse_y > 10 and mouse_y < 310)))
		Gosu.draw_rect(8, 8, 304, 304, Gosu::Color::YELLOW, ZOrder::PLAYER, mode=:default)
	end
	if (@selected_album == 2 or ((mouse_x > 10 and mouse_x < 310) and (mouse_y > 320 and mouse_y < 620)))
		Gosu.draw_rect(8, 318, 304, 304, Gosu::Color::YELLOW, ZOrder::PLAYER, mode=:default)
	end
	if (@selected_album == 3 or ((mouse_x > 320 and mouse_x < 620) and (mouse_y > 10 and mouse_y < 310)))
		Gosu.draw_rect(318, 8, 304, 304, Gosu::Color::YELLOW, ZOrder::PLAYER, mode=:default)
	end
	if (@selected_album == 4 or ((mouse_x > 320 and mouse_x < 620) and (mouse_y > 320 and mouse_y < 620)))
		Gosu.draw_rect(318, 318, 304, 304, Gosu::Color::YELLOW, ZOrder::PLAYER, mode=:default)
	end
  end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR
	def draw_background
		draw_quad(0, 0, TOP_COLOR, 
				  WIDTH, 0, TOP_COLOR, 
				  0, HEIGHT, BOTTOM_COLOR, 
				  WIDTH, HEIGHT, BOTTOM_COLOR, 
				  ZOrder::BACKGROUND)
	end

	def draw()
		draw_background()
		draw_albums()
		
		if @picked_tracks != nil	# Draw the track list for the selected album
			display_album(@picked_album)
			ypos = 250
			@picked_tracks.each do |track|
				display_tracks(track, ypos)
				ypos += 50
			end
		end

		if @played_track # Highlight the track being played
			@track_font.draw_text("Now playing: #{@played_track.name}", TrackLeftX, 450, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
			draw_buttons()
		end
	end

	def display_albums()
		music_file = File.new('albums.txt', "r")
		albums = read_albums(music_file)
		music_file.close()
		@picked_album = albums[@selected_album - 1]
		@picked_tracks = @picked_album.tracks
	end

	def display_album(album)
		@track_font.draw_text(album.title, TrackLeftX, 10, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::RED)
		@track_font.draw_text("Artist: #{album.artist}", TrackLeftX, 60, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::RED)
		@track_font.draw_text("Year: #{album.date}", TrackLeftX, 110, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::RED)
		@track_font.draw_text("Genre: #{$genre_names[album.genre.to_i()]}", TrackLeftX, 160, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::RED)
	end

	def display_tracks(track, ypos)
		@track_font.draw_text(track.name, TrackLeftX, ypos, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
	end

 	def needs_cursor? 
		true 
	end

	def button_down(id)
		case id
	    when Gosu::MsLeft
	    	# Display selected album's information and tracks
			if ((mouse_x > 10 and mouse_x < 310) and (mouse_y > 10 and mouse_y < 310))
				@selected_album = 1
				display_albums()
			elsif ((mouse_x > 10 and mouse_x < 310) and (mouse_y > 320 and mouse_y < 620))
				@selected_album = 2	
				display_albums()			
			elsif ((mouse_x > 320 and mouse_x < 620) and (mouse_y > 10 and mouse_y < 310))
				@selected_album = 3
				display_albums()				
			elsif ((mouse_x > 320 and mouse_x < 620) and (mouse_y > 320 and mouse_y < 620))
				@selected_album = 4	
				display_albums()		
			elsif @selected_album != nil
				button_functions()
			end
		end
	end

	# Detects if a 'mouse sensitive' area has been clicked on and returns the selected track's index
	def button_functions()
		select_track()
		sound_setting()
		track_toggling()
	end

	def select_track() # Choose a track to play
		if ((mouse_x > 650 and mouse_x < 1200) and (mouse_y > 250 and mouse_y < 290))
			@track = 0
			playTrack(@track, @picked_album)
		elsif ((mouse_x > 650 and mouse_x < 1200) and (mouse_y > 300 and mouse_y < 340))
			@track = 1
			playTrack(@track, @picked_album)
		elsif ((mouse_x > 650 and mouse_x < 1200) and (mouse_y > 350 and mouse_y < 390))
			@track = 2
			playTrack(@track, @picked_album)
		end
		return @track
	end

	# Takes a track index and an Album and plays the Track from the Album
	def playTrack(track, album)
		@played_track = album.tracks[track]
		if @song # stop any song being played
			@song.stop()
		end
		@song = Gosu::Song.new(@played_track.location)
		@song.play(false)
   	end

	def sound_setting()
		if ((mouse_x > 660 and mouse_x < 690) and (mouse_y > 510 and mouse_y < 540)) #mute button
			if @song.volume != 0
				@initial_volume = @song.volume
				@song.volume = 0
			else  
				@song.volume = @initial_volume
			end
		elsif ((mouse_x > 700 and mouse_x < 730) and (mouse_y > 510 and mouse_y < 540)) # decrease volume
			@song.volume -= 0.1
		elsif ((mouse_x > 872 and mouse_x < 902) and (mouse_y > 510 and mouse_y < 540)) # increase volume
			@song.volume += 0.1
		end
	end

	def track_toggling()
		if ((mouse_x > 735 and mouse_x < 765) and (mouse_y > 500 and mouse_y < 530)) # previous song
			if (@track > 0)
				@track -= 1
				playTrack(@track, @picked_album)
			end
		elsif ((mouse_x > 788 and mouse_x < 828) and (mouse_y > 500 and mouse_y < 550)) # pause/play button
			if @pause_status == "images/pause.png"
				@pause_status = "images/play.png"
				@song.pause()
			else  
				@pause_status = "images/pause.png"
				@song.play(false)
			end
		elsif ((mouse_x > 830 and mouse_x < 860) and (mouse_y > 510 and mouse_y < 540)) # next song
			if (@track < (@picked_album.tracks.length() - 1))
				@track += 1
				playTrack(@track, @picked_album)
			end
		elsif ((mouse_x > 914 and mouse_x < 944) and (mouse_y > 512 and mouse_y < 542)) #replay button
			@song.stop()
			@song.play(false)
		end
	end

end

# Show is a method that loops through update and draw
MusicPlayerMain.new.show if __FILE__ == $0