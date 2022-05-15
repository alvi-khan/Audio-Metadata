import 'package:flutter/material.dart';

class MissingArt extends StatelessWidget {
  const MissingArt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
            Icons.library_music_rounded,
            color: Colors.white24,
            size: 50
        ),
        SizedBox(height: 20),
        Text(
            "No Cover Found.",
            style:
            TextStyle(color: Colors.white24, fontSize: 20)
        )
      ],
    );
  }
}