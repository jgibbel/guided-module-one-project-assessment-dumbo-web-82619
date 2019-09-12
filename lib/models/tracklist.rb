class Tracklist < ActiveRecord::Base 
    belongs_to :playlist
    belongs_to :song 

    def add_add
        # Open the list with songs that include?() = false
        #create a method that updates the playlist with new songs


        # prompt = TTY::Prompt.new 
        # new_name = prompt.ask("What is your username")
        # self.update(username: new_name)
        # self.account_information
    end

    def remove_tracklist
        # Open a list with current songs
        # create a method that allows the user to select and delete the song
        prompt = TTY::Prompt.new
        playlist_instance = self.playlist
        if prompt.yes?("Are you sure you want to PERMANENTLY DELETE this Track from your Playlist?")
        self.destroy
        playlist_instance.edit_playlist
        else
        playlist_instance.edit_playlist
        end
    end

end 