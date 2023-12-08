import 'dart:io';
import 'package:audio_metadata/metadata_notifier.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:file/memory.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CoverImage extends StatefulWidget {
  const CoverImage({super.key, required this.coverUrl});
  final String coverUrl;

  @override
  State<CoverImage> createState() => _CoverImageState();
}

class _CoverImageState extends State<CoverImage> {
  File? image;
  bool loading = false;
  late MetadataNotifier metadata;

  void downloadImage() async {
    if (widget.coverUrl == "") {
      setState(() => image = null);
      return;
    }

    setState(() => loading = true);
    var res = await http.get(Uri.parse(widget.coverUrl));
    String filename = widget.coverUrl.split("/").last;
    File file = MemoryFileSystem().file(filename);
    await file.writeAsBytes(res.bodyBytes);
    metadata.song?.cover = file;
    setState(() {
      image = file;
      loading = false;
    });
  }

  void getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result == null) return;
    setState(() => image = File(result.files.first.path!));
    metadata.song?.cover = image;
  }

  @override
  void didUpdateWidget(CoverImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.coverUrl != oldWidget.coverUrl) downloadImage();
  }

  @override
  Widget build(BuildContext context) {
    metadata = Provider.of<MetadataNotifier>(context, listen: false);

    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(50.0),
        child: CircularProgressIndicator(strokeWidth: 5),
      );
    }

    return GestureDetector(
      onTap: () => getImage(),
      child: image == null
          ? const Icon(
              Icons.library_music_rounded,
              color: Colors.white24,
              size: 50,
            )
          : Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.file(
                    image!,
                    cacheHeight: 250,
                    cacheWidth: 250,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    padding: const EdgeInsets.all(10),
                    color: Colors.redAccent,
                    splashRadius: 0.1,
                    onPressed: () {
                      setState(() => image = null);
                    },
                    icon: const Icon(Icons.clear_rounded),
                  ),
                ),
              ],
            ),
    );
  }
}
