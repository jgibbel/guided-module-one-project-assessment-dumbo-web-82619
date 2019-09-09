#SEED DATA
User.destroy_all
Playlist.destroy_all
Song.destroy_all 
Tracklist.destroy_all 

u1 = User.create(name: "Gabriel", username: "gabriel", password: "password")
u2 = User.create(name: "James", username: "james", password: "password")
u3 = User.create(name: "Alex", username: "alex", password: "password")

p1 = Playlist.create(name: "playlist1", user_id: u1.id, mood: "vibez")

s1= Song.create(title: "Song1", artist: "Artist1", genre: "Genre1")
s2= Song.create(title: "Song2", artist: "Artist1", genre: "Genre1")
s3= Song.create(title: "Song3", artist: "Artist1", genre: "Genre1")
s4= Song.create(title: "Song4", artist: "Artist1", genre: "Genre1")
s5= Song.create(title: "Song5", artist: "Artist2", genre: "Genre2")
s6= Song.create(title: "Song6", artist: "Artist2", genre: "Genre2")
s7= Song.create(title: "Song7", artist: "Artist2", genre: "Genre2")
s8= Song.create(title: "Song8", artist: "Artist2", genre: "Genre2")

