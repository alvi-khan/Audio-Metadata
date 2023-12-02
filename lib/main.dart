import 'package:audio_metadata/file-details.dart';
import 'package:audio_metadata/file-select.dart';
import 'package:audio_metadata/metadata-notifier.dart';
import 'package:audio_metadata/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(ChangeNotifierProvider<MetadataNotifier>(
      create: (context) => MetadataNotifier(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scrollbarTheme: Theme.of(context).scrollbarTheme.copyWith(
              thumbColor: MaterialStateProperty.all(Colors.white10),
              crossAxisMargin: -4),
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                isDense: true,
                fillColor: Colors.blueGrey.shade800,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        const BorderSide(color: Colors.white12, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 2)),
                hintStyle: TextStyle(color: Colors.blueGrey.shade200),
              ),
          textTheme:
              GoogleFonts.manropeTextTheme(Theme.of(context).textTheme.apply(
                    fontSizeFactor: 1.2,
                    bodyColor: Colors.white,
                  ))),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Row(
                  children: const [Search(), Expanded(child: FileDetails())])),
          const FileSelect(),
        ],
      ),
    );
  }
}
