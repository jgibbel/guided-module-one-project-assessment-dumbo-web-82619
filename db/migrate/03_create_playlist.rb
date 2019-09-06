class CreatePlaylist < ActiveRecord::Migration[5.2]
    def change
      create_table :playlists do |t|
        t.string :playlist_title
        t.string :user_id
        t.string :mood
      end
    end
  end