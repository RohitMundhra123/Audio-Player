import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:soundplayer/list.dart';
import 'package:soundplayer/sound.dart';
import 'package:soundplayer/utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound Player',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(color: Colors.green)),
          
      initialRoute: MyRoutes.list,
      debugShowCheckedModeBanner: false,
      routes: {
        MyRoutes.sound: (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as List<Object?>;
          return SoundPlayer(
            data: args[0]
                as List<SongModel>, // Assuming 'data' is of type dynamic
            index: args[1] as int, // Assuming 'index' is of type int
          );
        },
        MyRoutes.list: (context) =>const ListAudio()
      },
    );
  }
}
