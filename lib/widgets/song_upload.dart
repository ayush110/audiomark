import 'package:flutter/material.dart';
import 'package:songhut/constants.dart';

class SongUpload extends StatelessWidget {
  const SongUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, // use whichever suits your need

        children: [
          FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            backgroundColor: Colors.grey,
            child: const Icon(Icons.upload),
          ),
          FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.play_arrow),
          ),
          FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            backgroundColor: Colors.black,
            child: const Icon(Icons.apple),
          ),
          FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.waves_sharp),
          ),
        ],
      ),
      const SizedBox(height: 20),
      const Divider(
        thickness: 1,
      )
    ]);
  }
}
