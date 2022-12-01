import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:songhut/constants.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../../coming_soon.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton(
      {super.key,
      required this.audioPlayer,
      required this.audioRoom,
      required this.song});
  final AudioPlayer audioPlayer;
  final OnAudioRoom audioRoom;
  final SongModel song;
  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  List<FavoritesEntity> outList = [];
  List<FavoritesEntity> getFavSongs() {
    dynamic a = 1;
    a = widget.audioRoom.queryFavorites().then((result) => {
          setState(() {
            outList = result;
          })
        });
    return outList;
  }

  bool favouriteOrNot() {
    List<FavoritesEntity> temp = [];
    temp = getFavSongs();

    bool favourite = false;
    for (var element in temp) {
      if (element.displayName == widget.song.displayName) {
        favourite = true;
        setState(() {
          entityKey = element.key;
        });
        break;
      }
    }

    return favourite;
  }

  Color heartColor = kLightColor3;
  int entityKey = -1;

  @override
  Widget build(BuildContext context) {
    setState(() {
      heartColor = favouriteOrNot() ? Colors.red : kLightColor3;
    });
    return IconButton(
      onPressed: () {
        if (!favouriteOrNot()) {
          setState(() {
            heartColor = Colors.red;
          });
          dynamic temp = widget.audioRoom.addTo(
            RoomType.FAVORITES,
            widget.song.getMap.toFavoritesEntity(),
          );
        } else {
          setState(() {
            heartColor = kLightColor3;
          });
          dynamic deleteFromResult = OnAudioRoom().deleteFrom(
            RoomType.FAVORITES,
            entityKey,
          );
        }
      },
      icon: Icon(
        Icons.favorite,
        color: heartColor,
      ),
    );
  }
}
