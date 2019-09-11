class User < ActiveRecord::Base
    has_many :playlists
    has_many :tracklists, through: :playlists

    # attr_accessor :name, :username, :password 


    # def self.handle_returning_user
    #     puts "What is your username?"
    #     username = gets.chomp
    #     if !User.find_by(username: username)
    #       TTY::Prompt.new.keypress("User not found. Please enter a valid name. Press any key to try again.")
    #       Interface.run_interface
    #     else puts "What is your password?"
    #         password = gets.chomp
    #         if User.find_by(username: username).password == password 
    #             User.find_by(username: username)
    #         else TTY::Prompt.new.keypress("Incorrect password, press any key to restart")
    #             Interface.run_interface
    #         end 
    #     end
    # end

    def self.handle_returning_user
        prompt = TTY::Prompt.new
        music_note = prompt.decorate('🎵')
        user_hash = prompt.collect do 
            key(:username).ask("What is your username?")
            key(:password).mask("What is your password?", mask: music_note)
        end
        
       if user_object = User.find_by(username: user_hash[:username], password: user_hash[:password])

            return user_object

        else TTY::Prompt.new.keypress("Incorrect credentials, press any key to restart")
            Interface.run_interface
        end   
    end


    def self.handle_new_user
        name = TTY::Prompt.new.ask("What is your name?")
        username = TTY::Prompt.new.ask("Set a username") 
        password = TTY::Prompt.new.ask("Set a password")
        User.create(name: name, username: username, password: password)
    end

    # def new_playlist(playlist_name)
    #     Playlist.create(self, playlist_name)
    # end 

    def account_information
        prompt = TTY::Prompt.new 
        prompt.select("Name: #{name}, Username: #{username}, Password: #{password}") do |menu|
            menu.choice "Change Name", -> {self.change_name}
            menu.choice "Change Username", -> {self.change_username}
            menu.choice "Change Password", -> {self.change_password}
            menu.choice "Delete Account", -> {self.delete_account}
            menu.choice "Back", -> {Interface.new.main_menu(self)}
        end 
    end

    def change_name
        prompt = TTY::Prompt.new 
        new_name = prompt.ask("What is your new name")
        self.update(name: new_name)
        self.account_information
    end
    
    def change_username
        prompt = TTY::Prompt.new 
        new_name = prompt.ask("What is your username")
        self.update(username: new_name)
        self.account_information
    end

    def change_password
        prompt = TTY::Prompt.new 
        new_name = prompt.ask("What is your new password")
        self.update(password: new_name)
        self.account_information
    end

    
    def delete_account
        prompt = TTY::Prompt.new
        if prompt.yes?("PERMANENTLY DELETE")
        self.destroy
        Interface.run_interface
        else
        Interface.new.main_menu(self)
        end
    end

    
    def my_playlists
        prompt = TTY::Prompt.new 
        system "clear"

        choices = self.playlists.map {|playlist| playlist.name}
        ##ERROR: Playlist.last is not being associated with the user!
        if choices.length == 0 
            choices << "Go create a new Playlist!"
        end
        
        choices << ["","Back"]
        new_choice = prompt.select("Your playlists", choices)

        if new_choice == "Back" || new_choice == "" || new_choice == "Go create a new Playlist!"
            Interface.new.main_menu(self)
        else
            Playlist.list_of_tracks(new_choice, self)
        end
    end

    def display_playlist
        system "clear"
        prompt = TTY::Prompt.new 
        puts "Display Playlists 🎧 🎼"
        puts ""
    
        choices = self.playlists.map {|playlist| playlist.name}
        ##ERROR: Playlist.last is not being associated with the user!
        if choices.length == 0 
            choices << "Go create a new Playlist!"
        end
        
        choices << ["","Back"]
        new_choice = prompt.select("Select the playlist you want to edit:", choices)

        if new_choice == "Back" || new_choice == "" || new_choice == "Go create a new Playlist!"
            Interface.new.main_menu(self)
        else
            playlist = Playlist.find_by(name:new_choice)
            playlist.edit_playlist
        end

    end


end 
