class Playlist < ActiveRecord::Base 
    belongs_to :user
    has_many :tracklists
    has_many :songs, through: :tracklists 

    def self.list_of_tracks(playlist_name)
        prompt = TTY::Prompt.new
        system "clear"
        list = self.find_by(name == playlist_name)
        tracks = list.tracklists.map {|track| track.song.title}
        puts tracks
        #refactor track display
    end 

    def self.make_new(user_object)
        system "clear"
        prompt = TTY::Prompt.new
        name = prompt.ask("Name your playlist")
        mood = prompt.ask("Give your playlist a mood")
        new_playlist = Playlist.create(user_id: user_object.id, name: name, mood: mood)
        # binding.pry
        songs_to_add = Song.display_songs()
        i = 1
        songs_to_add.each do |song|
            Tracklist.create(playlist_id: new_playlist.id, song_id: song.id, track_num: i)
            i += 1
        end
    end 
end 