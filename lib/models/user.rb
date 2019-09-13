class User < ActiveRecord::Base
    has_many :playlists
    has_many :tracklists, through: :playlists

    def self.handle_returning_user
        prompt = TTY::Prompt.new
        music_note = prompt.decorate('🎵')
        user_hash = prompt.collect do 
            key(:username).ask("Welcome Back! What is your username? ")
            key(:password).mask("What is your password? ", mask: music_note)
        end
        
       if user_object = User.find_by(username: user_hash[:username], password: user_hash[:password])

            return user_object

        else TTY::Prompt.new.keypress("Incorrect credentials, press any key to restart.")
            Interface.run_interface
        end   
    end

    def self.handle_new_user
        name = TTY::Prompt.new.ask("What is your name? ")
        new_username = TTY::Prompt.new.ask("Set a username: ") 
        
        if new_username == nil || new_username == ""  
            self.invalid_new_user()
        elsif User.find_by(username: new_username) != nil
            self.invalid_new_user()
        else
            password = self.password_check()
            User.create(name: name, username: new_username, password: password)
        end
    end

    def self.invalid_new_user
        system "clear"
        puts "Invalid or existing username. Please, try it again."
        sleep (2)
        Interface.run_interface
    end

    def self.password_check
        password = TTY::Prompt.new.ask("Set a password:")

        if password == nil || password == ""
            system "clear"
            puts "Invalid Password. Please, try it again."
            sleep (2)
            self.handle_new_user
        else
            return password
        end
    end

    def account_information
        prompt = TTY::Prompt.new 
        prompt.select("Name: #{name}, Username: #{username}, Password: #{password}", per_page: 10) do |menu|
            menu.choice "Change Name", -> {self.change_name}
            menu.choice "Change Username", -> {self.change_username}
            menu.choice "Change Password", -> {self.change_password}
            menu.choice "Delete Account", -> {self.delete_account}
            menu.choice "", -> {Interface.new.main_menu(self)}
            menu.choice "Back", -> {Interface.new.main_menu(self)}
        end 
    end

    def change_name
        prompt = TTY::Prompt.new 
        new_name = prompt.ask("What is your new name?")
        self.update(name: new_name)
        self.account_information
    end
    
    def change_username
        prompt = TTY::Prompt.new 
        new_name = prompt.ask("What is your new username?")
        self.update(username: new_name)
        self.account_information
    end

    def change_password
        prompt = TTY::Prompt.new 
        new_name = prompt.ask("What is your new password?")
        self.update(password: new_name)
        self.account_information
    end
    
    def delete_account
        prompt = TTY::Prompt.new
        if prompt.yes?("Are you sure you want to PERMANENTLY DELETE you account?")
        self.destroy
        Interface.run_interface
        else
        Interface.new.main_menu(self)
        end
    end

    
    def my_playlists
        prompt = TTY::Prompt.new 
        system "clear"
        
        choices_object = Playlist.all.select {|playlist| playlist.user_id == self.id.to_s}
        
        choices = choices_object.map{|playlist| playlist.name}
    
        if choices.length == 0 
            choices << "Go create a new Playlist!"
        end
        
        choices << ["","Back"]
        new_choice = prompt.select("Here's your playlists' library:", choices, per_page: 10)

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
    
        choices_object = Playlist.all.select {|playlist| playlist.user_id == self.id.to_s}
        choices = choices_object.map{|playlist| playlist.name}

        if choices.length == 0 
            choices << "Go create a new Playlist!"
        end
        
        choices << ["","Back"]
        new_choice = prompt.select("Select the playlist you want to edit:", choices, per_page: 10)

        if new_choice == "Back" || new_choice == "" || new_choice == "Go create a new Playlist!"
            Interface.new.main_menu(self)
        else
            playlist = Playlist.find_by(name:new_choice)
            playlist.edit_playlist
        end

    end


end 
