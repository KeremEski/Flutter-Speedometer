import 'package:flutter/material.dart';
import 'dart:io'; // Process.run() için gerekli

class Parlaklik extends StatefulWidget {
  const Parlaklik({super.key});

  @override
  State<Parlaklik> createState() => _ParlaklikState();
}

class _ParlaklikState extends State<Parlaklik> {
  // Ses ve parlaklık seviyelerini kontrol edecek fonksiyonlar
  void _increaseVolume() async {
    await _runCommand('amixer', ['sset', 'Master', '5%+']);
  }

  void _decreaseVolume() async {
    await _runCommand('amixer', ['sset', 'Master', '5%-']);
  }

  void _increaseBrightness() async {
    await _runCommand('brightnessctl', ['set', '+10%']);
  }

  void _decreaseBrightness() async {
    await _runCommand('brightnessctl', ['set', '10%-']);
  }

  // Terminal komutunu çalıştıran yardımcı fonksiyon
  Future<void> _runCommand(String command, List<String> arguments) async {
    try {
      ProcessResult result = await Process.run(command, arguments);
      if (result.exitCode == 0) {
        print('${command} başarıyla çalıştırıldı');
      } else {
        print('Hata: ${result.stderr}');
      }
    } catch (e) {
      print('Komut çalıştırılamadı: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ses ve Parlaklık Kontrolü')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ses Kontrol Butonları
            ElevatedButton(
              onPressed: _increaseVolume,
              child: const Text('Ses Artır'),
            ),
            ElevatedButton(
              onPressed: _decreaseVolume,
              child: const Text('Ses Azalt'),
            ),
            const SizedBox(height: 32),
            // Parlaklık Kontrol Butonları
            ElevatedButton(
              onPressed: _increaseBrightness,
              child: const Text('Parlaklık Artır'),
            ),
            ElevatedButton(
              onPressed: _decreaseBrightness,
              child: const Text('Parlaklık Azalt'),
            ),
          ],
        ),
      ),
    );
  }
}
