import 'dart:io';

class SystemControlService {
  // Singleton instance
  static final SystemControlService _instance =
      SystemControlService._internal();

  factory SystemControlService() {
    return _instance;
  }

  SystemControlService._internal();

  /// Ses seviyesini 0.0 - 1.0 arası ayarlar
  Future<void> setVolume(double level) async {
    final percent = (level * 100).toInt().clamp(1, 100);
    await _runCommand('amixer', ['sset', 'Master', '$percent%']);
  }

  /// Parlaklık seviyesini 0.0 - 1.0 arası ayarlar
  Future<void> setBrightness(double level) async {
    final percent = (level * 100).toInt().clamp(5, 100);
    await _runCommand('brightnessctl', ['set', '$percent%']);
  }

  /// Mevcut ses seviyesini getir (0.0 - 1.0 arası)
  Future<double> getVolume() async {
    try {
      final result = await Process.run('amixer', ['sget', 'Master']);
      if (result.exitCode == 0) {
        final output = result.stdout as String;
        final match = RegExp(r'\[(\d{1,3})%\]').firstMatch(output);
        if (match != null) {
          final volume = int.parse(match.group(1)!);
          return volume / 100.0;
        }
      }
    } catch (e) {
      print('Ses seviyesi okunamadı: $e');
    }
    return 0.5; // Varsayılan
  }

  /// Mevcut parlaklık seviyesini getir (0.0 - 1.0 arası)
  Future<double> getBrightness() async {
    try {
      final maxResult = await Process.run('brightnessctl', ['max']);
      final currentResult = await Process.run('brightnessctl', ['get']);

      if (maxResult.exitCode == 0 && currentResult.exitCode == 0) {
        final max = int.tryParse(maxResult.stdout.toString().trim());
        final current = int.tryParse(currentResult.stdout.toString().trim());

        if (max != null && current != null && max > 0) {
          return current / max;
        }
      }
    } catch (e) {
      print('Parlaklık okunamadı: $e');
    }
    return 0.5; // Varsayılan
  }

  Future<void> _runCommand(String command, List<String> arguments) async {
    try {
      final result = await Process.run(command, arguments);
      if (result.exitCode != 0) {
        print('Hata: ${result.stderr}');
      }
    } catch (e) {
      print('Komut çalıştırılamadı: $e');
    }
  }
}
