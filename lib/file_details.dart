import 'package:audio_metadata/cover_image.dart';
import 'package:audio_metadata/metadata_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileDetails extends StatefulWidget {
  const FileDetails({super.key});

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

    return Stack(children: [
      Padding(
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
                        child: Text("Title: ", textAlign: TextAlign.right),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: titleController,
                          onChanged: (title) => metadata.song?.title = title,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      const SizedBox(
                        width: 60,
                        child: Text("Artist: ", textAlign: TextAlign.right),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: artistController,
                          onChanged: (artist) => metadata.song?.artist = artist,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      const SizedBox(
                        width: 60,
                        child: Text("Album: ", textAlign: TextAlign.right),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: albumController,
                          onChanged: (album) => metadata.song?.album = album,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 60,
                          child: Text("Cover: ", textAlign: TextAlign.right),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(
                                  color: Colors.white12,
                                  width: 3,
                                ),
                                color: Colors.blueGrey.shade800,
                              ),
                              width: 250,
                              height: 250,
                              child: CoverImage(coverUrl: coverUrl),
                            ),
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
                      onChanged: (lyrics) => metadata.song?.lyrics = lyrics,
                      expands: true,
                      maxLines: null,
                      style: const TextStyle(fontSize: 16, height: 2),
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      if (metadata.loading)
        Container(
          color: Colors.black87,
          child: const Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: CircularProgressIndicator(
                strokeWidth: 10,
                color: Colors.white12,
              ),
            ),
          ),
        ),
    ]);
  }
}
