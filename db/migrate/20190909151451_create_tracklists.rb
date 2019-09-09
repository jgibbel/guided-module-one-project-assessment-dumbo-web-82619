class CreateTracklists < ActiveRecord::Migration[5.2]
  def change
    create_table :tracklists do |t|
      t.string :playlist_id
      t.string :song_id
      t.string :track_num
  end
end
end
