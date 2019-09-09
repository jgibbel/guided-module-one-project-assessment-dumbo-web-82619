class CreatePlaylists < ActiveRecord::Migration[5.2]
  def change
    create_table :playlists do |t|
      t.string :user_id
      t.string :name 
      t.string :mood
  end
end
end
