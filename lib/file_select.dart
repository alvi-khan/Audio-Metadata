import 'package:audio_metadata/metadata_notifier.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taggy/taggy.dart' hide FileType;

class FileSelect extends StatefulWidget {
  const FileSelect({super.key});

  @override
  State<FileSelect> createState() => _FileSelectState();
}

class _FileSelectState extends State<FileSelect> {
  String filepath = "";

  void error(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        padding: const EdgeInsets.all(15),
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          left: 500,
          right: 500,
        ),
      ),
    );
  }

  void saveFile() async {
    if (filepath == "") error("No audio file.");
    Song? song = Provider.of<MetadataNotifier>(context, listen: false).song;
    if (song == null) {
      error("No metadata to save.");
      return;
    } else {
      List<Picture> pictures = [];
      if (song.cover != null) {
        Picture picture = Picture(
          picType: PictureType.CoverFront,
          picData: song.cover!.readAsBytesSync(),
        );
        pictures.add(picture);
      }

      Tag tag = Tag(
        tagType: TagType.FilePrimaryType,
        trackTitle: song.title,
        trackArtist: song.artist,
        album: song.album,
        pictures: pictures,
        lyrics: song.lyrics,
      );

      await Taggy.writePrimary(path: filepath, tag: tag, keepOthers: false);
    }
  }

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["mp3", "flac"],
        lockParentWindow: true,
        dialogTitle: "Select File");
    if (result == null) return;
    setState(() => filepath = result.files.first.path!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white12, width: 2)),
      ),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () => getFile(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.blueGrey.shade500,
            ),
            child: const Text("Select File"),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade800,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white12, width: 2),
              ),
              child: Text(filepath),
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () => saveFile(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.blueGrey.shade500,
            ),
            child: const Icon(Icons.save_outlined, size: 32),
          ),
        ],
      ),
    );
  }
}
