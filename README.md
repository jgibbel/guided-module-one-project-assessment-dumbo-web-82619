A Command Line Application Made by:
Gabriel Kutik (https://github.com/Gabrielkq)
Alex Mendes (https://github.com/mendes-develop)
James Gibbel (https://github.com/jgibbel) 

-----------------------------------------------

Command Line Interface Tune Player: aka cliTunes
(written by Gabriel)

This application allows unique users to create unique playlists out of a database of songs.  From these playlists users can listen to their music or find more information about the song and artist. 

CRUD

CREATE

Users can create unique accounts with their name, username, and password, by choosing New User from the Welcome Menu.  If a username has already been taken, the user will be denied creation of the account and be asked to chooser another name.

In Create Playlists, a unique playlist is created as a unique collection of songs by a user and are given a name and a mood.

Due to the nature of the many to many relationship between songs and playlists, and joiner model of Tracklist was created. In Edit Playlist, when a player adds a song, they are a creating a new Tracklist instance as the bridge between the playlist and the song. 

READ

Users can read their name, username, and password in the option Account Information.  Users can read a list of their playlists on My Playlist.  Users can read a list of songs on a specific playlist by choosing that playlist.  Users are given a variety of options to read the song database in order to create a playlist, with such options as a list of all songs by title, list of songs by artist, list of songs by genre, search by song’s artist, and search by song’s title.  

UPDATE

Users can go to Account Information to change/update their name, their username, or their password.  Users can go to Edit Playlist and change/update the name and mood of the playlist.

DESTRUCTION

Users can destroy their accounts in account information. Users can destroy their playlist in Edit Playlist. Through Edit Playlist, when a user deletes a song off of a playlist, they are in actuality. destroying the joiner model Tracklist instance between the Playlist and the Song.

Key Design Features:

User menu navigation was achieved through TTY:prompt, which availed our team of many interactive methods to utilize for engagement with the user.  Simple menu selection allowed for navigation through nodal tree branch architecture for our user experience with the up and down keys and pressing enter. During the creation or edit of a Playlist, when presented with a array of possible choices (e.g. Viewing All Songs, Songs by Artist, Songs by Genre), a multi-select prompt was employed. This allows for the user to select or unselect from the list by pressing the spacebar, and then all or none of the designated selections are chosen by pressing the return key. When choosing to delete anything, a user given a failsafe binary prompt of Y/n.  

Dead ends were handled two manner of ways. In the case where a new user tried to access My Playlists or Edit Playlist without first creating one, they are informed that they need to create a playlist first and are returned to the Main Menu with any keystroke.  Paramount to the functionally and ease of use for the user was the implementation of a Back button appended to most menu options, which forgivingly allows for backtracking in the case of unintentional user error, and provides a sense of open flow through the navigation of the menus.
 
While the objective of the project was to satisfy the parameters of CRUD utilizing Active Records relations on database tables, in order to bring the merely conceptual into the realization of an actual functional program, Users were given the option of playing the tracks on their playlist and were provided the option of finding more information about the track being played on YouTube, Google, and Wikipedia all through a Command Line Interface.  


