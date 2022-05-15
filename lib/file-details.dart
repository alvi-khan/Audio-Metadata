import 'package:audio_metadata/missing-art.dart';
import 'package:flutter/material.dart';

class FileDetails extends StatelessWidget {
  const FileDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: const [
                    SizedBox(
                        width: 60,
                        child: Text("Title: ", textAlign: TextAlign.right)
                    ),
                    SizedBox(width: 10),
                    Expanded(child: TextField()),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  children: const [
                    SizedBox(
                        width: 60,
                        child: Text("Artist: ", textAlign: TextAlign.right,)
                    ),
                    SizedBox(width: 10),
                    Expanded(child: TextField()),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  children: const [
                    SizedBox(
                        width: 60,
                        child: Text("Album: ", textAlign: TextAlign.right,)
                    ),
                    SizedBox(width: 10),
                    Expanded(child: TextField()),
                  ],
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(
                          width: 60,
                          child: Text("Cover: ", textAlign: TextAlign.right)
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.white38, width: 2)
                              ),
                              width: 300,
                              height: 300,
                              child: const MissingArt()
                            )
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),
          ),
          const SizedBox(width: 50),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Text("Lyrics: "),
                SizedBox(height: 20),
                Expanded(
                    child: TextField(
                      expands: true,
                      maxLines: null,
                      style: TextStyle(fontSize: 18),
                      textAlignVertical: TextAlignVertical.top,
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}