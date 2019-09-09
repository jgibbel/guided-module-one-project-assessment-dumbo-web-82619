class Song < ActiveRecord::Base 
    has_many :tracklists 
    has_many :playlists, through: :tracklists 

end 