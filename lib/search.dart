import 'dart:convert';
import 'package:audio_metadata/metadata_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Result {
  String title = "";
  String artist = "";
  Result(this.title, this.artist);
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final headers = {"Authorization": "Bearer ${dotenv.env["API_KEY"]}"};

  Map<String, Result> results = {};
  String selectedSong = "";
  bool loading = false;
  String searchTerm = "";
  TextEditingController textController = TextEditingController();

  Color selectedColor = Colors.blueGrey.shade500;
  Color hoverColor = Colors.blueGrey.shade700;
  Color transparent = Colors.transparent;

  void search(String query) async {
    setState(() {
      searchTerm = query;
      loading = true;
    });
    var url = Uri.parse("https://api.genius.com/search?q=$query");
    var res = await http.get(url, headers: headers);
    Map<String, Result> results = {};
    if (res.statusCode == 200) {
      var songs = jsonDecode(res.body)["response"]["hits"];
      for (var song in songs) {
        String title = song["result"]["title"];
        String artist = song["result"]["primary_artist"]["name"];
        String id = song["result"]["id"].toString();
        results[id] = Result(title, artist);
      }
    }
    setState(() {
      this.results = results;
      loading = false;
    });
  }

  void selectSong(String songID) {
    setState(() => selectedSong = songID);
    Provider.of<MetadataNotifier>(context, listen: false).getSong(songID);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: const Border(
          right: BorderSide(
            color: Colors.white12,
            width: 2,
          ),
        ),
        color: Colors.blueGrey.shade800,
      ),
      child: Column(
        children: [
          TextField(
            controller: textController,
            style: const TextStyle(fontSize: 16),
            onSubmitted: (query) {
              if (query.isNotEmpty) search(query);
            },
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Search",
              suffixIcon: textController.text.isEmpty
                  ? null
                  : IconButton(
                      color: Colors.redAccent,
                      splashRadius: 0.1,
                      onPressed: () => setState(() {
                        textController.text = "";
                        searchTerm = "";
                        results.clear();
                      }),
                      icon: const Icon(Icons.clear_rounded),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          if (loading)
            const Text("Loading...")
          else if (searchTerm.isNotEmpty && results.isEmpty)
            const Text("No results found.")
          else
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(right: 10),
                shrinkWrap: true,
                children: results.entries.map((entry) {
                  return Material(
                    color:
                        selectedSong == entry.key ? selectedColor : transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      highlightColor: selectedColor,
                      splashColor: selectedColor,
                      hoverColor: selectedSong == entry.key
                          ? selectedColor
                          : hoverColor,
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => selectSong(entry.key),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Text(entry.value.title),
                            Text(
                              entry.value.artist,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }
}
