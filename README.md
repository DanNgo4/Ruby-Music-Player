# Ruby-Music-Player
University Project, First Year Semester 1

Demonstration video: https://www.youtube.com/watch?v=DIy8mJinQjk

Overview:
This project is a simple music player developed using Ruby and the Gosu library. It provides a graphical user interface (GUI) for users to browse albums, select tracks, and control playback. The player allows users to view album artwork, track information, and play/pause tracks.

Features:
1. Graphical User Interface (GUI):
  - The GUI presents album artwork and track information to users.
  - Users can interact with the interface using mouse clicks to select albums and tracks.

2. Album Selection:
  - Users can browse through available albums displayed on the screen.
  - Each album is represented by its artwork, and users can click on an album to view its tracks.

3. Track Selection and Playback:
  - Users can select individual tracks from an album to play.
  - Playback controls allow users to play, pause, skip to the next or previous track, and replay the current track.

4. Volume Control:
  - The player includes volume control functionality, allowing users to adjust the volume level of the currently playing track.
  - Users can mute/unmute the audio and increase/decrease the volume using dedicated buttons.

Implementation Details:
- Dependencies:
  The project relies on the Gosu library, which provides a simple interface for creating 2D games and applications in Ruby.

- User Interface:
  The GUI is built using Gosu's drawing capabilities, allowing for the display of album artwork, track names, and playback controls.
  
- Album and Track Information:
  Album data is read from an external text file (albums.txt), which contains information such as album title, artist, release year, genre, and track names.
  Track information is displayed dynamically based on the selected album.

- Interaction Handling:
  User interactions, such as mouse clicks, are handled to enable album and track selection, as well as playback control.
  Track selection triggers the loading and playback of the chosen track.

- Playback Control:
  Playback controls, including play/pause, volume adjustment, and track navigation, are implemented to provide users with control over the music playback experience.

Conclusion:
This music player project demonstrates the use of Ruby and the Gosu library to create a basic graphical interface for music playback. It provides users with an intuitive way to explore albums, select tracks, and control playback, offering a simple yet functional music listening experience.
