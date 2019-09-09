class Playlist < ActiveRecord::Base 
    has_many :tracklists
    has_many :songs, through: :tracklists 
end 