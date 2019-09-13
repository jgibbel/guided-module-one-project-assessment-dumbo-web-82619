# require 'launchy'
class Playlist < ActiveRecord::Base 

    belongs_to :user
    has_many :tracklists
    has_many :songs, through: :tracklists 

    def self.make_new(user_object)
        system "clear"
        prompt = TTY::Prompt.new
        new_playlist_string = prompt.ask("Name your playlist: ") 

        if new_playlist_string == ""
            puts "Your Playlist must have a name."
            sleep(3)
            self.make_new(user_object)
        end
       
        if user_object.playlists == [] || !(user_object.playlists.map {|playlist| playlist.name}.include?(new_playlist_string))

            mood = prompt.ask("Give your playlist a mood: ")
            new_playlist = Playlist.create(user_id: user_object.id, name: new_playlist_string, mood: mood)
            new_playlist.save

            songs_to_add = Song.search_songs_menu(new_playlist)
            i = 1

            songs_to_add.each do |song|
                new_tracklist = Tracklist.create(playlist_id: new_playlist.id, song_id: song.id, track_num: i)
                i += 1
                new_tracklist.save
                
            end

            self.list_of_tracks(new_playlist_string, user_object)
    
        else
            puts "A Playlist with this name already exists. Please try another name."
            sleep(3)
            self.make_new(user_object)
        end
    end 

    def self.list_of_tracks(playlist_name, user)
        prompt = TTY::Prompt.new
        system "clear"
        list = self.find_by(name: playlist_name)
        tracks = list.songs.map {|song| "#{song.title} by #{song.artist}"}
        if tracks.size == 0 
            tracks << ["Empty Playlist"]
        end
        tracks << ["", "Back"]
        new_choice = prompt.select("Your songs: ", tracks, per_page: 10)
        music_file = new_choice.split(" by ").first
        url_artist = new_choice.split(" by ").last
        if new_choice == "Back" || new_choice == "" || new_choice == "Empty Playlist"
            user.my_playlists
        else
        pid = fork{ exec 'afplay', "lib/audio_files/#{music_file}.mp3" }
        prompt.select("Playing") do |menu|
            menu.choice "Stop", -> {Playlist.kill_helper(playlist_name, user)}
            menu.choice "Want to see it on YouTube?", -> {self.song_to_yt(music_file, url_artist, playlist_name, user)}
            menu.choice "See Google results?", -> {self.song_to_google(music_file, url_artist, playlist_name, user)}
            menu.choice "Find it's Wikipedia page?", -> {self.song_to_wiki(music_file, url_artist, playlist_name, user)}
            menu.choice "", -> {user.my_playlists}
            menu.choice "Back", -> {user.my_playlists}
        end 
        end 
    end
 
    def self.kill_helper(playlist_name, user)
        pid = fork{ exec 'killall afplay' }
        Playlist.list_of_tracks(playlist_name, user)
    end

    def self.song_to_yt(song, artist, playlist_name, user)
        search = song + "+" + artist
        song = search.sub("","+")
        Launchy.open("https://www.youtube.com/results?search_query=#{song}")
        self.list_of_tracks(playlist_name, user)
    end

    def self.song_to_google(song, artist, playlist_name, user)
        search = song + "+" + artist
        song = search.sub("","+")
        Launchy.open("https://www.google.com/search?q=#{song}")
        self.list_of_tracks(playlist_name, user)
    end
    def self.song_to_wiki(song, artist, playlist_name, user)
        search = song + "+" + artist
        song = search.sub("","+")
        Launchy.open("https://en.wikipedia.org/wiki/Special:Search?search=#{song}")
        self.list_of_tracks(playlist_name, user)
    end

    def edit_playlist
        prompt = TTY::Prompt.new 
        prompt.select("Playlist: #{self.name}, Mood: #{self.mood}", per_page: 10) do |menu|
            menu.choice "Add Song (not working yet)", -> {Song.search_songs_menu(self)}#display songs not on Playlist () -> pick and add
            menu.choice "Remove Song (not working yet)", -> {self.songs_playlist}#display songs on Playlist -> pick and delete
            menu.choice "Rename Playlist", -> {self.rename_playlist}
            menu.choice "Change Mood", -> {self.change_mood}
            menu.choice "Delete Playlist", -> {self.delete_playlist}
            menu.choice "", -> {Interface.new.main_menu(self.user)}
            menu.choice "Back", -> {Interface.new.main_menu(self.user)}
        end 
    end

    def songs_playlist
        if self.tracklists.size == 0 
            puts "You have no songs to be deleted"
            sleep(3)
            self.edit_playlist
        else
            prompt = TTY::Prompt.new
            songs = self.songs
            songs_menu = songs.map {|song| song.title} # converting into string
            new_choice = prompt.select("Pick the song you wish to delete: ", songs_menu, per_page: 10)
            song_instance =  Song.all.find_by(title: new_choice)

            tracklist = Tracklist.all.find_by(playlist_id: self.id, song_id: song_instance.id)
            tracklist.remove_tracklist()
        end
    end

    def rename_playlist
        prompt = TTY::Prompt.new 
        new_name = prompt.ask("What is your new Playlist name?")
        self.update(name: new_name)
        self.edit_playlist
    end

    def change_mood
        prompt = TTY::Prompt.new 
        new_mood = prompt.ask("What is your new mood for this playlist?")
        self.update(mood: new_mood)
        self.edit_playlist
    end
    
    def delete_playlist
        prompt = TTY::Prompt.new
        if prompt.yes?("PERMANENTLY DELETE")
        user_instance = self.user
        self.destroy
        Interface.new.main_menu(user_instance)
        else
        Interface.new.main_menu(self.user)
        end
    end
end 