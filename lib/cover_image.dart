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
  bool isHovering = false;
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

  void clearImage() {
    setState(() => image = null);
  }

  void updateHoverState(isHovering) {
    setState(() => this.isHovering = isHovering);
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
        child: CircularProgressIndicator(
          strokeWidth: 5,
          color: Colors.white12,
        ),
      );
    }

    return FocusableActionDetector(
      onShowHoverHighlight: updateHoverState,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          if (image == null)
            const Icon(
              Icons.library_music_rounded,
              color: Colors.white24,
              size: 50,
            ),
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                image!,
                cacheHeight: 250,
                cacheWidth: 250,
              ),
            ),
          if (isHovering)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black38,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (image != null)
                    TextButton(
                      onPressed: () => clearImage(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Remove Cover"),
                    ),
                  if (image != null) const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => getImage(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.blueGrey.shade500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        Text(image == null ? "Select File" : "Replace Cover"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
