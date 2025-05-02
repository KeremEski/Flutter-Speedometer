import 'dart:async';
import 'dart:convert'; // JSON için import
import 'package:web_socket_channel/web_socket_channel.dart';

class BluetoothService {
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;

  BluetoothService._internal();

  WebSocketChannel? _channel;
  final StreamController<Map<String, String>> _controller =
      StreamController.broadcast();
  Stream<Map<String, String>> get metadataStream => _controller.stream;

  // WebSocket üzerinden Bluetooth metadata verilerini alacak
  Future<void> connect(String url) async {
    try {
      // WebSocket bağlantısını başlat
      _channel = WebSocketChannel.connect(Uri.parse(url));

      // WebSocket üzerinden gelen veriyi dinle
      _channel!.stream.listen(
        (data) {
          try {
            // WebSocket'ten gelen veri, String formatında ise JSON'a dönüştür
            final Map<String, dynamic> metadata = jsonDecode(data);

            // Veriyi stream'e ilet
            _controller.add({
              'title': metadata['title'] ?? 'Unknown',
              'artist': metadata['artist'] ?? 'Unknown',
              'album': metadata['album'] ?? 'Unknown',
            });
            print(metadata['title']);
          } catch (e) {
            print("Error parsing JSON: $e");
          }
        },
        onError: (error) {
          print("WebSocket Error: $error");
        },
        onDone: () {
          print("WebSocket bağlantısı kapatıldı.");
        },
        cancelOnError: true, // Eğer hata olursa stream'i durdur
      );
    } catch (e) {
      print("WebSocket bağlantısı kurulamadı: $e");
    }
  }

  void dispose() {
    _controller.close();
    _channel?.sink.close();
  }
}
