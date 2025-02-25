class Interface

    attr_reader :prompt
    attr_accessor :user

    def initialize()
        @prompt = TTY::Prompt.new 
    end 


    def self.run_interface
        cli = self.new
        user_object = cli.welcome
        cli.main_menu(user_object) 
    end

    def welcome
        system "clear"
        self.art
        puts "Welcome to cliTunes 🎧 🎼"
        puts "Your command line playlist maker!!"
        puts ""
        self.prompt.select("Are you a Returning or New User?") do |menu|
          menu.choice "Returning User", -> {User.handle_returning_user}
          menu.choice "New User", -> {User.handle_new_user}
          menu.choice "", -> {exit!}
          menu.choice "Exit", -> {exit!}
        end
    end

    def main_menu(user_object)
        system "clear"
        self.prompt.select("Welcome #{user_object.name}! Here is your menu of options:") do |menu| 
            menu.choice "My Playlists", -> {user_object.my_playlists}
            menu.choice "Create Playlist", -> {Playlist.make_new(user_object)}
            menu.choice "Edit Playlist", -> {user_object.display_playlist}
            menu.choice "Account Information", -> {user_object.account_information}
            menu.choice "", -> {Interface.run_interface}
            menu.choice "Exit", -> {Interface.run_interface}
        end 
    end 

    def art 
        system "clear"
        art = puts <<-"EOF"

                      .,,,.
                   .;;;;;;;;;,
                  ;;;'    `;;;,
                 ;;;'      `;;;
                 ;;;        ;;;
                 ;;;.      ;;;'
                 `;;;.    ;;;'
                  `;;;.  ;;;'
                   `;;',;;'
                    ,;;;'
                 ,;;;',;' ...,,,,...
              ,;;;'    ,;;;;;;;;;;;;;;,
           ,;;;'     ,;;;;;;;;;;;;;;;;;;,
          ;;;;'     ;;;',,,   `';;;;;;;;;;
         ;;;;,      ;;   ;;;     ';;;;;;;;;
        ;;;;;;       '    ;;;      ';;;;;;;
        ;;;;;;            .;;;      ;;;;;;;
        ;;;;;;,            ;;;;     ;;;;;;'
         ;;;;;;,            ;;;;   .;;;;;'
          `;;;;;;,           ;;;; ,;;;;;'
           `;;;;;;;,,,,,,,,,, ;;;; ;;;'
              `;;;;;;;;;;;;;;; ;;;; '
                  ''''''''''''' ;;;.
                       .;;;.    `;;;.
                      ;;;; '     ;;;;
                      ;;;;,,,..,;;;;;
                      `;;;;;;;;;;;;;'
                        `;;;;;;;;;'

        EOF
        art
    end
end