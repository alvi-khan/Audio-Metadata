import 'package:flutter/material.dart';

class MissingArt extends StatelessWidget {
  const MissingArt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
            Icons.library_music_rounded,
            color: Colors.blueGrey.shade300,
            size: 50
        ),
        const SizedBox(height: 20),
        Text(
            "No Cover Found.",
            style:
            TextStyle(color: Colors.blueGrey.shade300, fontSize: 20)
        )
      ],
    );
  }
}