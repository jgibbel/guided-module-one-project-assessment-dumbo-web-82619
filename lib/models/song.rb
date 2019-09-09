class Song 
    has_many :tracklists 
    has_many :playlists, through: :tracklists 

end 