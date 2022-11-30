//import 'package:audioplayers/audioplayers.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:provider/provider.dart';
import 'package:songhut/screens/songplayer/components/adjust_speed_button.dart';
import 'package:songhut/screens/songplayer/components/favorite_button.dart';
import 'package:songhut/screens/songplayer/components/loop_button.dart';
import 'package:songhut/screens/songplayer/components/shuffle_button.dart';
import '../../constants.dart';
import '../../provider/songModelProvider.dart';
import '../coming_soon.dart';

class SongPlayer extends StatefulWidget {
  const SongPlayer(
      {super.key,
      required this.songModelList,
      required this.audioPlayer,
      required this.audioRoom});
  final List<SongModel> songModelList;
  final AudioPlayer audioPlayer;
  final OnAudioRoom audioRoom;

  @override
  State<SongPlayer> createState() => _SongPlayerState();
}

class _SongPlayerState extends State<SongPlayer> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isPlaying = false;
  List<AudioSource> songList = [];

  int currentIndex = 0;
  RangeValues _currentRangeValues = const RangeValues(0.0, 0.0);
  RangeLabels _currentRangeLabels = const RangeLabels("0", "0");

  void popBack() {
    Navigator.pop(context);
  }

  void seekToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

  void resetConfigurations() {
    widget.audioPlayer.setSpeed(1.0);
    _position = const Duration(seconds: 0);
    _currentRangeValues = RangeValues(0, _duration.inSeconds.toDouble());

    playAudio();
  }

  Future<void> playAudio() async {
    if (_position.inSeconds.toInt() <= _currentRangeValues.start.toInt() ||
        _position.inSeconds.toInt() >= _currentRangeValues.end.toInt()) {
      widget.audioPlayer
          .seek(Duration(seconds: _currentRangeValues.start.toInt()));
    }

    widget.audioPlayer.play();
    _isPlaying = true;
    // await widget.audioPlayer.pause();
  }

  @override
  void initState() {
    super.initState();
    parseSong();
  }

  void parseSong() async {
    try {
      for (var element in widget.songModelList) {
        songList.add(
          AudioSource.uri(
            Uri.parse(element.uri!),
          ),
        );
      }
      widget.audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: songList),
      );

      widget.audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          setState(() {
            _duration = duration;

            _currentRangeValues =
                RangeValues(0, _duration.inSeconds.toDouble());
            _currentRangeLabels =
                RangeLabels("0", _duration.inSeconds.toString());
          });
        }
      });
      widget.audioPlayer.positionStream.listen((position) {
        setState(() {
          _position = position;
        });

        if (_position.inSeconds.toInt() >= _currentRangeValues.end.toInt()) {
          if (widget.audioPlayer.loopMode == LoopMode.all) {
            seekToSeconds(_currentRangeValues.start.toInt());
            playAudio();
          } else {
            widget.audioPlayer.pause();
          }
        }
      });

      playAudio();
      listenToEvent();
      listenToSongIndex();
    } on Exception catch (_) {
      popBack();
    }
  }

  void listenToEvent() {
    widget.audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        setState(() {
          _isPlaying = true;
        });
      } else {
        setState(() {
          _isPlaying = false;
        });
      }
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void listenToSongIndex() {
    widget.audioPlayer.currentIndexStream.listen(
      (event) {
        setState(
          () {
            if (event != null) {
              currentIndex = event;
            }
            context
                .read<SongModelProvider>()
                .setId(widget.songModelList[currentIndex].id);
          },
        );
      },
    );
  }

  _millisToMinutesAndSeconds(seconds) {
    int min = ((seconds / 60).toInt());
    int sec = ((seconds % 60).toInt());
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          width: double.infinity,
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      popBack();
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  const Text("Now Playing"),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ComingSoon()));
                    },
                    icon: const Icon(
                      Icons.more_horiz,
                      color: kLightColor,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: ArtWorkWidget(),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      widget.songModelList[currentIndex].displayNameWOExt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: widget.songModelList[currentIndex].artist !=
                                "<unknown>"
                            ? Text(
                                widget.songModelList[currentIndex].artist
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: kLightColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 1,
                              )
                            : null),
                    RangeSlider(
                      activeColor: kPrimaryColor,
                      inactiveColor: Colors.transparent,
                      values: _currentRangeValues,
                      min: 0.0,
                      max: _duration.inSeconds.toDouble(),
                      labels: _currentRangeLabels,
                      onChanged: (RangeValues value) {
                        setState(() {
                          _currentRangeValues = value;
                          _currentRangeLabels = RangeLabels(
                              _millisToMinutesAndSeconds(value.start),
                              _millisToMinutesAndSeconds(value.end));
                        });
                      },
                    ),
                    Slider(
                      mouseCursor: SystemMouseCursors.grab,
                      //thumbColor: Colors.red,
                      activeColor: kPrimaryColor,
                      inactiveColor: kLightColor2,
                      min: 0.0,
                      value: _position.inSeconds.toDouble(),
                      max: _duration.inSeconds.toDouble(),

                      onChanged: (value) {
                        setState(
                          () {
                            seekToSeconds(value.toInt());
                            value = value;
                          },
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _position.toString().split(".")[0],
                        ),
                        Text(
                          _duration.toString().split(".")[0],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (widget.audioPlayer.hasPrevious) {
                              widget.audioPlayer.seekToPrevious();
                              resetConfigurations();
                            }
                          },
                          icon: const CircleAvatar(
                            radius: 30,
                            backgroundColor: kLightColor2,
                            child: Icon(
                              color: Colors.black,
                              Icons.skip_previous_rounded,
                              size: 20.0,
                            ),
                          ),
                        ),
                        IconButton(
                          iconSize: 60,
                          onPressed: () {
                            setState(() {
                              if (_isPlaying) {
                                widget.audioPlayer.pause();
                              } else {
                                if (_position >= _duration) {
                                  seekToSeconds(0);
                                } else {
                                  playAudio();
                                }
                              }
                              _isPlaying = !_isPlaying;
                            });
                          },
                          icon: CircleAvatar(
                            radius: 30,
                            backgroundColor: kPrimaryColor,
                            child: Icon(
                              color: Colors.white,
                              _isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 30.0,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (widget.audioPlayer.hasNext) {
                              widget.audioPlayer.seekToNext();
                              resetConfigurations();
                            }
                          },
                          icon: const CircleAvatar(
                            radius: 30,
                            backgroundColor: kLightColor2,
                            child: Icon(
                              color: Colors.black,
                              Icons.skip_next_rounded,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FavoriteButton(
                            audioPlayer: widget.audioPlayer,
                            audioRoom: widget.audioRoom,
                            song: widget.songModelList[0]),
                        ShuffleButton(audioPlayer: widget.audioPlayer),
                        AdjustSpeed(audioPlayer: widget.audioPlayer),
                        LoopButton(audioPlayer: widget.audioPlayer),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: context.watch<SongModelProvider>().id,
      type: ArtworkType.AUDIO,
      artworkHeight: 300,
      artworkWidth: 300,
      artworkBorder: const BorderRadius.all(Radius.circular(30)),
      artworkFit: BoxFit.cover,
      nullArtworkWidget: Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(
            color: kPrimaryColor,
            border: Border.all(
              color: kPrimaryColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: const Icon(
          Icons.music_note_rounded,
          size: 200,
          color: Colors.white,
        ),
      ),
    );
  }
}
