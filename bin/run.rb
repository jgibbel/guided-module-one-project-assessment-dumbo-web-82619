
require_relative '../config/environment'

    cli = Interface.new 
    # binding.pry 
    user_object = cli.welcome

    # while !user_object do
    #     user_object = cli.welcome
    # end
        cli.main_menu(user_object)

    puts "hello world"
