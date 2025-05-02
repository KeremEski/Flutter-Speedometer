import 'package:car_multimedia/screens/layout.dart';
import 'package:car_multimedia/utils/assets/custom_colors.dart';
import 'package:car_multimedia/utils/assets/custom_text_styles.dart';
import 'package:car_multimedia/utils/assets/widgets/slider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: _homeScreen(),
    );
  }

  // Screens
  _homeScreen() {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _menuButtons(
                    Icons.directions_car_filled, "Araç", null, null, null),
                _menuButtons(
                    Icons.music_note_sharp, "Müzik", null, null, "music"),
                _menuButtons(Icons.phone, "Telefon", null, null, null),
                _menuButtons(Icons.settings, "Ayarlar", null, null, null),
                _menuButtons(Icons.settings, "Android Auto", true,
                    "lib/utils/assets/images/android_auto_logo.png", null),
                _menuButtons(Icons.settings, "Carplay", true,
                    "lib/utils/assets/images/carplay_logo.png", null),
                const Column(children: [
                  SizedBox(
                      width: 336,
                      child: CustomSlider(label: "Parlaklık", isVolume: false)),
                  SizedBox(
                      width: 336,
                      child: CustomSlider(label: "Ses", isVolume: true)),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widgets
  _menuButtons(IconData? icon, String text, bool? isImage, String? imagePath,
      String? route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, "/$route"),
      child: Container(
          height: 160,
          width: 160,
          decoration: BoxDecoration(
            color: CustomColors().darkColor1,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isImage == null || isImage == false
                  ? Icon(icon, size: 48, color: CustomColors().lightColor1)
                  : Image.asset(
                      imagePath!,
                      width: 48,
                      height: 48,
                    ),
              const SizedBox(height: 16),
              Text(
                text,
                style: CustomTextStyles().h3(CustomColors().lightColor1),
              ),
            ],
          )),
    );
  }
}
