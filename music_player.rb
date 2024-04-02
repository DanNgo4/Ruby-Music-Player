$genre_names = ["Null", "Pop", "Classic", "Jazz", "Rock"]

class Album 
    attr_accessor :artist, :title, :image, :date, :genre, :tracks 
    def initialize(artist, title, image, date, genre, tracks)
        @artist = artist 
        @title = title
        @image = image
        @date = date
        @genre = genre 
        @tracks = tracks 
    end 
end 

class Track 
    attr_accessor :name, :location 
    def initialize(name, location)
        @name = name 
        @location = location 
    end 
end

def read_albums(music_file)
    num_of_albums = music_file.gets.chomp()
    albums = Array.new()
    index = 0
    while (index < num_of_albums.to_i)
        album = read_album(music_file)
        albums << album 
        index += 1
    end 
    return albums
end 

def read_album(music_file)
    artist = music_file.gets.chomp()
    title = music_file.gets.chomp()
    image = music_file.gets.chomp()
    date = music_file.gets.chomp()
    genre = music_file.gets.chomp()
    tracks = read_tracks(music_file)
    album = Album.new(artist, title, image, date, genre, tracks)
    return album
end

def read_tracks(music_file)
    num_of_tracks = music_file.gets.chomp()
    tracks = Array.new()
    index = 0 
    while (index < num_of_tracks.to_i())
        track = read_track(music_file)
        tracks << track 
        index += 1
    end
    return tracks
end

def read_track(music_file)
    name = music_file.gets.chomp()
    location = music_file.gets.chomp()
    track = Track.new(name, location)
    return track 
end