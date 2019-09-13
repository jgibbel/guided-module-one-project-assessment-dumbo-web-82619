class Song < ActiveRecord::Base 
    has_many :tracklists 
    has_many :playlists, through: :tracklists 

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
            menu.choice "All by Title", -> {Song.sort_by_title(playlist_instance) }
            menu.choice "Artist", -> {Song.sort_by_artist(playlist_instance)}
            menu.choice "Genre", -> {Song..sort_by_genre(playlist_instance)}
            menu.choice "Search By Title", -> {Song.search_by_title(playlist_instance) }
            menu.choice "Search by Artist", -> {Song.search_by_artist(playlist_instance) }
            menu.choice "Exit", -> {Interface.new.main_menu(playlist_instance.user)}
        end
    end 

    def self.sort_by_title(playlist_instance) 
        prompt = TTY::Prompt.new
        song_list = Song.all.map {|song| "#{song.title} by #{song.artist}"}.sort 
        song_choice = self.menu_back(song_list, "Songs:")   
        if !song_choice
            self.search_songs_menu(playlist_instance)
        else
            song_choice = song_choice.split(" by ").first
            song_as_array = [song_choice]
            self.add_selected_songs(song_as_array, playlist_instance)
        end
    end

    def self.menu_back(array, string)
        array << ["", "Back"]
        choice = TTY::Prompt.new.select(string, array, per_page: 11)
        if choice == "Back" || choice == ""
            return nil
        else
            choice
        end
    end

    def self.sort_by_artist(playlist_instance) 
        prompt = TTY::Prompt.new
        artist_list = Song.all.map {|song| song.artist}.uniq.sort 
        artist_choice = prompt.select("Artists:", artist_list, per_page: 10) 
        artist_songs = Song.all.select {|song| song.artist == artist_choice}.map {|song| song.title}
        song_select = prompt.multi_select("Pick Songs by #{artist_choice}", artist_songs)
        # binding.pry
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
        if songs_found = Song.where("title LIKE ?","%#{search_term}%")
        songs_list = songs_found.map {|song| "#{song.title} by #{song.artist}"}
        choice = prompt.select("Found songs:", songs_list)
        choice = [choice]
        
        self.add_selected_songs(choice, playlist_instance)
        self.search_songs_menu(playlist_instance)
            
        else 
            puts "No matching song was found. Returning to Song Search"
            sleep(2)
            self.search_songs_menu(playlist_instance) 
        end 
    end

    def self.search_by_artist(playlist_instance) 
        prompt = TTY::Prompt.new
        search_term = prompt.ask("Enter your search term:")
        if artists_found = Song.where("artist LIKE ?","%#{search_term}%")
            artists_list =  artists_found.map {|song| "#{song.artist}"}.uniq
            choice = prompt.select("Found Artists:", artists_list)
            found_artist_songs = Song.all.select {|song| song.artist == choice}
            artist_name = found_artist_songs.first.artist
            song_names = found_artist_songs.map {|song| song.title}
            song_selection = prompt.multi_select("Pick Songs by #{artist_name}", song_names)
            self.add_selected_songs(song_selection, playlist_instance)
        else 
            puts "No matching artist was found. Returning to Song Search"
            sleep(2)
            self.search_songs_menu(playlist_instance) 
        end 
    end 

    def self.add_selected_songs(song_array, playlist_instance)
        tracks = Tracklist.all.select {|track| track.playlist_id = playlist_instance.id}
        nums = tracks.map {|track| track.track_num.to_i}.sort
        if nums == []
            i = 1
        else 
        i = nums.last + 1 
        end
        song_array.each do |songstring| 
            songstring = songstring.split(" by ").first 
            song = Song.all.find_by(title: songstring)
            Tracklist.create(playlist_id: playlist_instance.id, song_id: song.id, track_num: i)
            i += 1 
        end 
        self.search_songs_menu(playlist_instance)
    end

end 