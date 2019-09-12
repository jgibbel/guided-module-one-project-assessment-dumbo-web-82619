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
        # binding.pry
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


    def self.sort_by_title(playlist_instance) 
        prompt = TTY::Prompt.new
        song_list = Song.all.map {|song| "#{song.title} by #{song.artist}"}.sort 
        # song_list << ["", "Back"]
        song_choice = self.menu_back(song_list, "Songs:")   
        if !song_choice
        self.search_songs_menu(playlist_instance)
        # song_choice = prompt.select("Songs:", song_list, per_page: 40)
        # if song_choice == "Back" || song_choice == ""
        #     self.search_songs_menu(playlist_instance)
        else
        song_choice = song_choice.split(" by ").first
        song_as_array = [song_choice]
        # binding.pry
        self.add_selected_songs(song_as_array, playlist_instance)
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
        if Song.all.map {|song| song.title}.include?(search_term)
            found_song = Song.all.find_by(title: search_term)
            song_title = found_song.title
            song_artist = found_song.artist
            if prompt.yes?("Found: #{song_title} by #{song_artist}, Add to playlist?")
                song_array = []
                song_array << found_song.title
                self.add_selected_songs(song_array, playlist_instance)
            else 
                self.search_songs_menu(playlist_instance)
            end 
        else 
            puts "No matching song was found. Returning to Song Search"
            sleep(2)
            self.search_songs_menu(playlist_instance) 
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
            self.search_songs_menu(playlist_instance) 
        end 
    end 


    # def self.add_selected_songs(song_array, playlist_instance)
    #     # if song_array.class != Array 
    #     #     song_object = song_array 
    #     #     song_array = []
    #     #     song_title_array << song_object 
    #     # end 
    #         tracks = Tracklist.all.select {|track| track.playlist_id = playlist_instance.id}
    #         # binding.pry
    #         nums = tracks.map {|track| track.track_num.to_i}.sort
    #         i = nums.last + 1 
    #     song_array.each do |songstring| 
    #         song = Song.all.find_by(title: songstring)
    #         Tracklist.create(playlist_id: playlist_instance.id, song_id: song.id, track_num: i)
    #         i += 1 
    #     end 
    #     binding.pry
    #     self.search_songs_menu(playlist_instance)
    # end

    def self.add_selected_songs(song_array, playlist_instance)
        # if song_array.class != Array 
        #     song_object = song_array 
        #     song_array = []
        #     song_title_array << song_object 
        # end 
            tracks = Tracklist.all.select {|track| track.playlist_id = playlist_instance.id}
            # binding.pry
            nums = tracks.map {|track| track.track_num.to_i}.sort
            # binding.pry
            if nums == []
                i = 1
            else 
            i = nums.last + 1 
            end
        song_array.each do |songstring| 
            song = Song.all.find_by(title: songstring)
            Tracklist.create(playlist_id: playlist_instance.id, song_id: song.id, track_num: i)
            i += 1 
        end 
        # binding.pry
        self.search_songs_menu(playlist_instance)
    end

end 