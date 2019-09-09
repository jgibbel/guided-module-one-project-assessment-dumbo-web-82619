require_relative '../config/environment'

cli = Interface.new 
binding.pry 
user_object = cli.welcome
cli.main_menu(user_object)


puts "hello world"
