# require 'tty-prompt'

class Interface

    attr_reader :prompt
    attr_accessor :user

    def initialize()
        @prompt = TTY::Prompt.new 

    end 

    def welcome
        system "clear"
        puts "Welcome"
        self.prompt.select("Returning or New User?") do |menu|
          menu.choice "Returning", -> {User.handle_returning_user}
          menu.choice "New", -> {User.handle_new_user}
        end
    end

    def main_menu(user_object)
        system "clear"
        self.prompt.select("Menu Items:") do |menu| 
            menu.choice "Account Information", -> {user_object.account_information} 
            menu.choice "My Playlists", -> {user_object.my_playlists}
            menu.choice "Create Playlist", -> {Playlist.make_new(user_object)}
            menu.choice "Exit"
        end 
    end 
end 