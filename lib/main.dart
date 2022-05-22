// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:musicplayer/musicpage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

late File file;

void main() {
  runApp(MaterialApp(
    routes: {'/musicpage': (context) => MusicPage()},
    home: Scaffold(
      body: MyApp(),
      backgroundColor: Colors.black,
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> setPath() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path.toString());
        audioPlayer.play(file.path, isLocal: true);
        audioPlayer.setReleaseMode(ReleaseMode.LOOP);

        playpause = "⏸";
      });
      // audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    } else {
      // User canceled the picker

    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text(
          'Pick a Song',
          style: TextStyle(backgroundColor: Colors.blue),
        ),
        onPressed: () {
          setPath();
          Navigator.pushNamed(context, '/musicpage');
        },
      ),
    );
  }
}
