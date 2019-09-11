class Song < ActiveRecord::Base 
    has_many :tracklists 
    has_many :playlists, through: :tracklists 

    def prompt()
        prompt = TTY::Prompt.new
    end

    def self.display_songs
        prompt = TTY::Prompt.new
        songs = Song.all.map {|song| song.title}
        selected = prompt.multi_select("pick your songs", songs, per_page: 10)
        selected.map do |title|
            Song.find_by(title: title)
        end
    end

    


end 