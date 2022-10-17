import 'package:flutter/material.dart';

class SongPlayer extends StatelessWidget {
  const SongPlayer({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.pop(context, "Returned from SecondPage");
          },
          child: const Text('Go Back'),
        ),
      ),
    );
  }
}
