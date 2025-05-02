import 'package:car_multimedia/screens/layout.dart';
import 'package:car_multimedia/utils/assets/custom_colors.dart';
import 'package:car_multimedia/utils/assets/custom_text_styles.dart';
import 'package:flutter/material.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});
  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  bool isPlaying = true;
  @override
  Widget build(BuildContext context) {
    return Layout(
      child: _musicScreen(),
    );
  }

  _musicScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              const Color.fromARGB(31, 0, 0, 0),
              CustomColors().primaryColor,
            ],
            center: Alignment.center,
            radius: 0.7,
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 500, // Genişlik sınırı
            height: 300, // Yükseklik sınırı
            child: Row(
              children: [
                // Kapak görseli
                Container(
                  width: 225,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage("lib/utils/assets/images/cover.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Bilgi ve butonlar
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Şarkı adı
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Sessizim nefessizim bu ara kederliyim",
                            style: CustomTextStyles().h2(Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Sanatçı adı
                        Text(
                          "Kerem Eski",
                          style: CustomTextStyles().p1(Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Oynatma kontrolleri
                        const Expanded(child: SizedBox()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.skip_previous),
                              color: Colors.white,
                              iconSize: 32,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isPlaying = !isPlaying;
                                });
                              },
                              icon: isPlaying
                                  ? const Icon(Icons.play_circle)
                                  : const Icon(Icons.pause_circle),
                              color: Colors.white,
                              iconSize: 64,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.skip_next),
                              color: Colors.white,
                              iconSize: 32,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
