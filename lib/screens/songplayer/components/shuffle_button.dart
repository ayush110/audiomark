import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../constants.dart';

class ShuffleButton extends StatefulWidget {
  const ShuffleButton({super.key, required this.audioPlayer});
  final AudioPlayer audioPlayer;
  @override
  State<ShuffleButton> createState() => _ShuffleButtonState();
}

class _ShuffleButtonState extends State<ShuffleButton> {
  Color shuffleColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        widget.audioPlayer
            .setShuffleModeEnabled(!widget.audioPlayer.shuffleModeEnabled);

        setState(() {
          widget.audioPlayer.shuffleModeEnabled
              ? shuffleColor = kPrimaryColor
              : shuffleColor = Colors.black;
        });
      },
      icon: Icon(
        Icons.shuffle_sharp,
        color: shuffleColor,
        size: 24.0,
      ),
    );
  }
}
