require 'tty-prompt'

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


      end

end 