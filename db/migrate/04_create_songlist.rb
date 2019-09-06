class CreateSonglist < ActiveRecord::Migration[5.2]
    def change
      create_table :songlists do |t|
        t.string :playlist_id
        t.string :user_id
        t.string :track_num
      end
    end
  end