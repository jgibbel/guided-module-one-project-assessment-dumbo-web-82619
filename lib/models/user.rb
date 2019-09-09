class User < ActiveRecord::Base
    has_many :playlists
    has_many :tracklists, through: :playlists

    # attr_accessor :name, :username, :password 


    def self.handle_returning_user
        puts "What is your username?"
        username = gets.chomp
        if !User.find_by(username: username)
          TTY::Prompt.new.keypress("User not found. Please enter a valid name. Press any key to try again.")
          nil
        else puts "What is your password?"
            password = gets.chomp
            if User.find_by(username: username).password == password 
                User.find_by(username: username)
            else TTY::Prompt.new.keypress("Incorrect password, press any key to reenter")
                nil 
            end 
        end
    end

    def self.handle_new_user
        name = TTY::Prompt.new.ask("What is your name?")
        username = TTY::Prompt.new.ask("Set a username") 
        password = TTY::Prompt.new.ask("Set a password")
        User.create(name: name, username: username, password: password)
    end

    def new_playlist(playlist_name)
        Playlist.create(self, playlist_name)
    end 

    def account_information
        prompt = TTY::Prompt.new 
        prompt.select("Name: #{name}, Username: #{username}, Password: #{password}") do |menu|
            menu.choice "Change Account Info", -> {}
            menu.choice "Delete Account", -> {}
            menu.choice "Back", -> {}
        end 
    end

    def my_playlists
        prompt = TTY::Prompt.new 
        system "clear"
        choices = self.playlists.map {|playlist| playlist.name}
        # prompt.enum_select("Your Playlists:")
        new_choice = prompt.select("Your playlists", choices)
        # TODO: list_of_tracks
        Playlist.list_of_tracks(new_choice)
    end

end 