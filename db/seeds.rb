#SEED DATA
User.destroy_all
Playlist.destroy_all
Song.destroy_all 
Tracklist.destroy_all 

u1 = User.create(name: "Gabriel", username: "gabriel", password: "password")
u2 = User.create(name: "James", username: "james", password: "password")
u3 = User.create(name: "Alex", username: "alex", password: "password")

p1 = Playlist.create(name: "playlist1", user_id: u1.id, mood: "vibez")

# s1= Song.create(title: "Song1", artist: "Artist1", genre: "Genre1")
# s2= Song.create(title: "Song2", artist: "Artist1", genre: "Genre1")
# s3= Song.create(title: "Song3", artist: "Artist1", genre: "Genre1")
# s4= Song.create(title: "Song4", artist: "Artist1", genre: "Genre1")
# s5= Song.create(title: "Song5", artist: "Artist2", genre: "Genre2")
# s6= Song.create(title: "Song6", artist: "Artist2", genre: "Genre2")
# s7= Song.create(title: "Song7", artist: "Artist2", genre: "Genre2")
# s8= Song.create(title: "Song8", artist: "Artist2", genre: "Genre2")

# song_seeds = [
# ["James Brown", "Soul", ["Get Up Offa That Thing", "I Got the Feeling", "Cold Sweat", "Get Up Sex Machine", "Papa Don't Take No Mess"]],
# ["Post Malone", "Rap", ["Sunflower", "White Iverson", "Congratulations", "Psycho"]],
# ["Eminem", "Rap", ["The Real Slim Shady", "'Till I Collapse", "Love the Way You Lie", "Cleanin' Out My Closet", "Rap God"]],
# ["Ol' Dirty Bastard", "Rap", ["Got Your Money", "Shimmy Shimmy Ya", "Tearz", "Protect Ya Neck", "Triumph"]],
# ["Lady Gaga", "Pop", ["Shallow", "Poker Face", "Bad Romance", "Million Reasons", "Applause", "Alejandro", "Judas"]],
# ["Kanye", "Rap",  ["Gold Digger", "Stronger", "Heartless", "Flashing Lights", "Mercy", "All of the Lights", "Fade"]]
# ]

# song_seeds.each do |artist|
#     artist[2].each do |title|
#         Song.create(title: title, artist: artist[0], genre: artist[1])
#     end 
# end

song_seeds = [
["Beyoncé", "Pop", ["Jealous", "Partition", "No Angel"]],
["Bbymutha", "Rap", ["Dancin On The Dick", "Indian Hair"]],
["Angie Stone", "RnB", ["Green Grass Vapours", "No More Rain (In This Cloud)"]],
["Doja Cat", "Rap",  ["Ice Cream Pussy", "Mace Windu"]],
["Chance the Rapper", "Rap", ["Juice", "Lost (ft. Noname)"]],
["Adele", "Ballad", ["Rolling In The Deep", "Rumor Has It", "Set Fire To The Rain"]],
["Awkwafina", "Rap", ["NYC Bitches", "Peggy Bundy", "Yellow Ranger"]]
]

song_seeds.each do |artist|
    artist[2].each do |title|
        Song.create(title: title, artist: artist[0], genre: artist[1])
    end 
end
