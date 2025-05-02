import 'package:car_multimedia/screens/home_screen.dart';
import 'package:car_multimedia/screens/music_screen.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  // Pencereyi tam ekran yapma true ya çek
  windowManager.setFullScreen(true);
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const HomeScreen(),
        '/music': (context) => const MusicScreen(),
      },
    );
  }
}
