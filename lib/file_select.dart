import 'package:audio_metadata/helper.dart';
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

  void saveFile() async {
    if (filepath == "") {
      notify(context, NotificationType.error, "No audio file.");
      return;
    }

    Song? song = Provider.of<MetadataNotifier>(context, listen: false).song;

    if (song == null) {
      notify(context, NotificationType.error, "No metadata to save.");
      return;
    }

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

    Taggy.writePrimary(
      path: filepath,
      tag: tag,
      keepOthers: false,
    ).whenComplete(() {
      notify(context, NotificationType.success, "Metadata Saved!");
    });
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
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.blueGrey.shade500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Select File"),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade800,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12, width: 2),
              ),
              child: Text(filepath),
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () => saveFile(),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.blueGrey.shade500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Icon(Icons.save_outlined, size: 32),
          ),
        ],
      ),
    );
  }
}
