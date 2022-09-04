# SongList

## Download and Play

Main task:

The app should show a list of songs. Every element of the list is a view that represents Song. Let’s call the view SongView.
SongView has a button that represents Song state:
- need to download: triggers downloading of the related audio file
- downloading: shows downloading progress, user actions should be ignored - play: current song is not playing, triggers playback
- pause: current song is playing, stops playback

The app data should be persistent. If the user has downloaded a few songs and killed the app right after that, the Songs data such as info and audio files will survive. The next time the user launches the app, the cached data should be shown first and then the data should be updated from the server.

## Architecture Diagram

![SongList Diagram drawio](https://user-images.githubusercontent.com/82820612/188321284-4242bca6-e43e-4acf-a711-d8ced6b52cff.svg)


## Sample Screenshot

![Screen Shot 2022-09-04 at 11 23 34 PM](https://user-images.githubusercontent.com/82820612/188321387-41efb6af-6525-47c5-97a5-5a25a5f651ba.png)
