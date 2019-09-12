class Tracklist < ActiveRecord::Base 
    belongs_to :playlist
    belongs_to :song 

    def remove_tracklist
        # Open a list with current songs
        # create a method that allows the user to select and delete the song
        prompt = TTY::Prompt.new
        playlist_instance = self.playlist
        if prompt.yes?("Are you sure you want to PERMANENTLY DELETE this tracklist?")
        self.destroy
        playlist_instance.edit_playlist
        else
        playlist_instance.edit_playlist
        end
    end

end 