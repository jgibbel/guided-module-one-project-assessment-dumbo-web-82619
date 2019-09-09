class User < ActiveRecord::Base
    has_many :playlists
    has_many :tracklists, through: :playlists
end 