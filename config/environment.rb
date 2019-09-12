require 'bundler'
require 'tty-prompt'
require 'audio-playback'
require 'launchy'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
ActiveRecord::Base.logger = nil
require_all 'lib'


