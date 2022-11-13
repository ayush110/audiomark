import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:songhut/constants.dart';

class LoopButton extends StatefulWidget {
  const LoopButton({super.key, required this.audioPlayer});
  final AudioPlayer audioPlayer;
  @override
  State<LoopButton> createState() => _LoopButtonState();
}

class _LoopButtonState extends State<LoopButton> {
  Color loopColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (widget.audioPlayer.loopMode == LoopMode.off) {
          widget.audioPlayer.setLoopMode(LoopMode.all);
          setState(() {
            loopColor = kPrimaryColor;
          });
        } else {
          widget.audioPlayer.setLoopMode(LoopMode.off);
          setState(() {
            loopColor = Colors.black;
          });
        }
      },
      icon: Icon(
        Icons.loop_rounded,
        color: loopColor,
        size: 24.0,
      ),
    );
  }
}
