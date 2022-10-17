import 'package:flutter/material.dart';
import 'package:songhut/constants.dart';
import 'package:songhut/widgets/song_upload.dart';

import '../widgets/song_tabs.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: const [
          SongUpload(),
          SongTabs(),
        ],
      ),
    );
  }
}
