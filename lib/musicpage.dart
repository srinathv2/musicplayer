import 'dart:io';
import 'dart:math' as math;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:musicplayer/main.dart';
import 'package:audioplayers/audioplayers.dart';

late AnimationController animationController;
late AudioPlayer audioPlayer;
bool isPlaying = false;
int c = 1;
Duration duration = Duration.zero;
Duration position = Duration.zero;
String playpause = '▶️';

class AnimateBuider extends StatefulWidget {
  const AnimateBuider({Key? key}) : super(key: key);

  @override
  State<AnimateBuider> createState() => _AnimateBuiderState();
}

class _AnimateBuiderState extends State<AnimateBuider>
    with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle: animationController.value * 2.0 * math.pi,
            child: child,
          );
        },
        child: SizedBox(
          height: 300,
          child: Image.asset('assets/images/ironheart.png'),
        ),
      ),
    );
  }
}

class MusicPage extends StatefulWidget {
  const MusicPage({Key? key}) : super(key: key);

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  Future<void> setPath() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path.toString());
        audioPlayer.play(file.path, isLocal: true);
        audioPlayer.setReleaseMode(ReleaseMode.LOOP);
        if (!isPlaying) {
          animationController.repeat();
        }
        playpause = "⏸";
      });
      // audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    } else {
      // User canceled the picker

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // animationController.stop();
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });
    audioPlayer.onDurationChanged.listen((change) {
      setState(() {
        duration = change;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((pos) {
      setState(() {
        position = pos;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playLocal() async {
    // if (c == 1) {
    //   await audioPlayer.play(file.path, isLocal: true);
    //   audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    //   setState(() {
    //     playpause = "⏸";
    //   });
    // } else {
    if (isPlaying) {
      setState(() {
        animationController.stop();
        playpause = '▶️';
      });
      audioPlayer.pause();
    } else {
      setState(() {
        animationController.repeat();
        playpause = "⏸";
      });
      audioPlayer.resume();
    }
    // }
    // c += 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: Text(
                'I...AM.......SRINATH REDDY',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
            AnimateBuider(),
            Slider(
                value: position.inSeconds.toDouble(),
                min: 0.0,
                max: duration.inSeconds.toDouble(),
                onChanged: (double value) async {
                  setState(() {
                    audioPlayer.seek(Duration(seconds: value.toInt()));
                    value = value;
                  });
                  // audioPlayer.resume();
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    position.toString().substring(2, 7),
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    duration.toString().substring(2, 7),
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    playLocal();
                  },
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.0),
                      child: Text(
                        playpause,
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  setPath();
                },
                child: Text(
                  'Pick a New Song',
                  style: TextStyle(backgroundColor: Colors.blue),
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
