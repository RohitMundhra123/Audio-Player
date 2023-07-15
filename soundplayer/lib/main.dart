import 'package:flutter/material.dart';
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
      initialRoute: MyRoutes.sound,
      debugShowCheckedModeBanner: false,
      routes: {
        MyRoutes.sound: (context) => SoundPlayer(),
      },
    );
  }
}
