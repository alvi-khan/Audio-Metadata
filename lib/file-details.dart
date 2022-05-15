import 'package:audio_metadata/metadata-notifier.dart';
import 'package:audio_metadata/missing-art.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileDetails extends StatefulWidget {
  const FileDetails({Key? key}) : super(key: key);

  @override
  State<FileDetails> createState() => _FileDetailsState();
}

class _FileDetailsState extends State<FileDetails> {
  TextEditingController titleController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  TextEditingController albumController = TextEditingController();
  TextEditingController lyricsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MetadataNotifier metadata = Provider.of<MetadataNotifier>(context);
    titleController.text = metadata.song?.title ?? "";
    artistController.text = metadata.song?.artist ?? "";
    albumController.text = metadata.song?.album ?? "";
    lyricsController.text = metadata.song?.lyrics ?? "";
    String coverUrl = metadata.song?.coverUrl ?? "";

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                        width: 60,
                        child: Text("Title: ", textAlign: TextAlign.right)
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                          controller: titleController,
                          style: const TextStyle(fontSize: 16),
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  children: [
                    const SizedBox(
                        width: 60,
                        child: Text("Artist: ", textAlign: TextAlign.right,)
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                          controller: artistController,
                          style: const TextStyle(fontSize: 16),
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  children: [
                    const SizedBox(
                        width: 60,
                        child: Text("Album: ", textAlign: TextAlign.right,)
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                          controller: albumController,
                          style: const TextStyle(fontSize: 16),
                        )
                    ),
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
                                border: Border.all(color: Colors.white12, width: 3),
                                color: Colors.blueGrey.shade800,
                              ),
                              width: 250,
                              height: 250,
                              child: coverUrl == "" ? const MissingArt() :
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  coverUrl,
                                  cacheHeight: 250,
                                  cacheWidth: 250,
                                ),
                              ),
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
              children: [
                const Text("Lyrics: "),
                const SizedBox(height: 20),
                Expanded(
                    child: TextField(
                      controller: lyricsController,
                      expands: true,
                      maxLines: null,
                      style: const TextStyle(fontSize: 16, height: 2),
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