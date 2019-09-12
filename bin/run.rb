
require_relative '../config/environment'

## Initial Run
    cli = Interface.new 
    user_object = cli.welcome
    cli.main_menu(user_object)

