import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:songhut/constants.dart';

import '../../coming_soon.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.audioPlayer});
  final AudioPlayer audioPlayer;
  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ComingSoon()));
      },
      icon: const Icon(
        Icons.favorite,
        color: kLightColor3,
      ),
    );
  }
}
