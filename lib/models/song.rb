class Song < ActiveRecord::Base 
    has_many :tracklists 
    has_many :playlists, through: :tracklists 

    def prompt()
        prompt = TTY::Prompt.new
    end

    def self.display_songs
        prompt = TTY::Prompt.new
        songs = Song.all.map {|song| song.title}
        selected = prompt.multi_select("pick your songs", songs)
        selected.map do |title|
            Song.find_by(title: title)
        end
    end

    def self.search_songs_menu(playlist_instance) 
        prompt = TTY::Prompt.new
        sort_function = prompt.select("Sort By:") do |menu|
            menu.choice "All by Title", -> {Song.display_songs}
            menu.choice "Artist", -> {}
            menu.choice "Genre", -> {}
            menu.choice "Search By Title", -> {}
            menu.choice "Search by Artist", -> {}
            menu.choice "Exit", -> {}
        end
    end 

    def self.sort_by_artist(playlist_instance) 
        prompt = TTY::Prompt.new
        artist_list = Song.all.map {|song| song.artist}.uniq.sort 
        artist_choice = prompt.select("Artists:", artist_list) 
        artist_songs = Song.all.select {|song| song.artist == artist_choice}.map {|song| song.title}
        song_select = prompt.multi_select("Pick Songs by #{artist_choice}", artist_songs)
        self.add_selected_songs(song_select, playlist_instance)
    end


    def self.sort_by_genre(playlist_instance)
        prompt = TTY::Prompt.new
        genre_list = Song.all.map {|song| song.genre}.uniq.sort 
        genre_choice = prompt.select("Genres:", genre_list) 
        genre_songs = Song.all.select {|song| song.genre == genre_choice}
        genre_artists = genre_songs.map {|song| song.artist}.uniq
        artist_select = prompt.select("Choose an Artist", genre_artists)
        artist_songs = Song.all.select {|song| song.artist == artist_select}.map {|song| song.title}
        song_select = prompt.multi_select("Pick Songs by #{artist_select}", artist_songs)
        self.add_selected_songs(song_select, playlist_instance)
    end 

    def self.search_by_title(playlist_instance) 
        prompt = TTY::Prompt.new
        search_term = prompt.ask("Enter your search term:")
        if Song.all.map {|song| song.title}.include?(search_term)
            found_song = Song.all.find_by {|song| song.title == search_term}
            song_title = found_song.title}
            song_artist = found_song.artist}
            if prompt.yes?("Found: #{song_title} by #{song_artist}, Add to playlist?")
                self.add_selected_songs(found_song, playlist_instance)
            else 
                self.search_songs_menu 
            end 
        else 
            puts "No matching song was found. Returning to Song Search"
            sleep(2)
            self.search_songs_menu 
        end 
    end

    def self.search_by_artist(playlist_instance) 
        prompt = TTY::Prompt.new
        search_term = prompt.ask("Enter your search term:")
        if Song.all.map {|song| song.artist}.include?(search_term)
            found_artist_songs = Song.all.select {|song| song.artist == search_term}
            artist_name = found_artist_songs.first.artist
            song_names = found_artist_songs.map {|song| song.title}
            song_selection = prompt.multi_select("Pick Songs by #{artist_name}", song_names)
            self.add_selected_songs(song_selection, playlist_instance)
        else 
            puts "No matching artist was found. Returning to Song Search"
            sleep(2)
            self.search_songs_menu 
        end 
    end 


    def self.add_selected_songs(song_array, playlist_instance)
        if song_array.type != array 
            song_object = song_array 
            song_array = []
            song_title_array << song_object 
        end 
            tracks = Tracklist.all.select {|track| track.playlist_id = playlist_instance.id}
            i = (tracks.sort_by(track_num).last.track_num) + 1 
        song_array.each do |song| 
            Tracklist.create(playlist_id: playlist_instance.id, song_id: song.id, track_num: i)
            i += 1 
        end 
    end

end 

