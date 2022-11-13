import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songhut/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:just_audio/just_audio.dart';
import 'package:songhut/screens/songplayer/song_player.dart';
import '../../provider/songModelProvider.dart';
import 'components/music_tile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _HomePage();
}

class _HomePage extends State<MyHomePage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  //final AudioCache _audioCache = AudioCache();

  List<SongModel> allSongs = [];

  requestPermission() async {
    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: kPrimaryColor,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Welcome Back!"),
              backgroundColor: kPrimaryColor,
            ),
            body: FutureBuilder<List<SongModel>>(
              // Default values:
              future: _audioQuery.querySongs(
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (context, item) {
                // Loading content
                if (item.data == null) return const CircularProgressIndicator();

                // When you try "query" without asking for [READ] or [Library] permission
                // the plugin will return a [Empty] list.
                if (item.data!.isEmpty) return const Text("Nothing found!");
                allSongs.addAll(item.data!);
                // You can use [item.data!] direct or you can create a:
                // List<SongModel> songs = item.data!;
                return Stack(
                  children: [
                    ListView.builder(
                      itemCount: item.data!.length,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<SongModelProvider>()
                                .setId(item.data![index].id);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SongPlayer(
                                        songModelList: [item.data![index]],
                                        audioPlayer: _audioPlayer)));
                          },
                          child: MusicTile(
                            songModel: item.data![index],
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SongPlayer(
                                      songModelList: allSongs,
                                      audioPlayer: _audioPlayer)));
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 15, 15),
                          child: const CircleAvatar(
                            backgroundColor: kPrimaryColor,
                            radius: 30,
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
