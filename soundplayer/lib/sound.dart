import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';

class SoundPlayer extends StatefulWidget {
  const SoundPlayer({super.key});

  @override
  State<SoundPlayer> createState() => _SoundPlayerState();
}

class _SoundPlayerState extends State<SoundPlayer> {
  final player = AudioPlayer();
  String abc = '';

  @override
  void initState() {
    super.initState();
    loadDuration();
  }

 void loadDuration() async {
  final duration = await player.setUrl(
    'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3',
  );

  final minutes = duration!.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  final minuteSecond = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

  setState(() {
    abc = duration.inHours > 0 ? '${duration.inHours}:$minuteSecond' : minuteSecond;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sound Player'),
        leading: const Icon(
          Icons.person,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                          hintText: '00:00',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                          hintText: abc,
                          hintStyle:
                              const TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green),
                        padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                      ),
                      child: const Text("Play",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onPressed: () {
                        player.play();
                      },
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green),
                        padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                      ),
                      child: const Text("Pause",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onPressed: () {
                        player.pause();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
