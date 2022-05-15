import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  Search({Key? key}) : super(key: key);
  final List<String> results = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.blueGrey.shade500, width: 2)),
        color: Colors.blueGrey.shade800,
      ),
      child: Column (
        children: [
          const TextField(
            decoration: InputDecoration(
                hintText: "Search",
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: results.map((result) {
                return Text(
                    result,
                    style: const TextStyle(height: 3)
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

}