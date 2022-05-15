import 'package:flutter/material.dart';

class FileSelect extends StatelessWidget {
  const FileSelect({Key? key}) : super(key: key);
  final String filepath = "";

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
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                primary: Colors.blueGrey.shade500,
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
                  border: Border.all(color: Colors.white12, width: 2)
                ),
                child: Text(filepath)
            ),
          ),
        ],
      ),
    );
  }
}