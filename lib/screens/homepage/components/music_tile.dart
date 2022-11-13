import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:songhut/screens/coming_soon.dart';
import 'package:songhut/utils/extensions/SongModelExtension.dart';

import '../../../constants.dart';

class MusicTile extends StatelessWidget {
  final SongModel songModel;

  const MusicTile({
    required this.songModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        songModel.displayNameWOExt,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(songModel.additionalSongInfo),
      trailing: IconButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ComingSoon()));
        },
        icon: const Icon(Icons.more_horiz),
      ),
      leading: QueryArtworkWidget(
        artworkHeight: 40,
        artworkWidth: 40,
        id: songModel.id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: const CircleAvatar(
          radius: 20,
          backgroundColor: kPrimaryColor,
          child: Icon(
            Icons.music_note,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
