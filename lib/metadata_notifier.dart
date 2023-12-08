import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';

class Song {
  String title = "";
  String artist = "";
  String album = "";
  String lyrics = "";
  String coverUrl = "";
  File? cover;
  Song(this.title, this.artist, this.album, this.lyrics, this.coverUrl);
}

class MetadataNotifier extends ChangeNotifier {
  final headers = {"Authorization": "Bearer ${dotenv.env["API_KEY"]}"};
  String songID = "";
  Song? song;
  bool loading = false;

  Future<String> getLyrics(String url) async {
    String lyrics = "";
    try {
      String responseBody = (await http.get(Uri.parse(url))).body;
      BeautifulSoup soup =
          BeautifulSoup(responseBody.replaceAll('<br/>', '\n'));
      lyrics = soup
          .findAll('div', class_: 'Lyrics__Container')
          .map((e) => e.getText().trim())
          .join('\n');
    } catch (e) {
      print(e);
    }
    return lyrics;
  }

  void getSong(String songID) async {
    if (songID != this.songID) {
      loading = true;
      notifyListeners();

      var url = Uri.parse("https://api.genius.com/songs/$songID");
      var res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        var song = jsonDecode(res.body)["response"]["song"];
        String title = song["title"];
        String artist = song["primary_artist"]["name"];
        String album = song["album"] == null ? "" : song["album"]["name"];
        String coverUrl =
            song["album"] == null ? "" : song["album"]["cover_art_url"];
        String lyrics = await getLyrics("https://genius.com${song["path"]}");
        this.song = Song(title, artist, album, lyrics, coverUrl);
        loading = false;
        notifyListeners();
      }
      this.songID = songID;
    }
  }
}
