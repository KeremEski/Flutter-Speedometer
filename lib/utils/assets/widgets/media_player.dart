import 'package:car_multimedia/services/bluetooth_service.dart';
import 'package:flutter/material.dart';

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  String songTitle = 'Unknown';
  String songArtist = 'Unknown';
  String songAlbum = 'Unknown';

  @override
  void initState() {
    super.initState();

    // FastAPI WebSocket sunucusuna bağlan
    BluetoothService().connect('ws://192.168.1.62:8000/ws/metadata');

    // Verileri dinle ve UI'yi güncelle
    BluetoothService().metadataStream.listen((data) {
      setState(() {
        songTitle = data['title'] ?? 'Unknown';
        songArtist = data['artist'] ?? 'Unknown';
        songAlbum = data['album'] ?? 'Unknown';
      });
    }, onError: (error) {
      print("WebSocket Error: $error");
    });
  }

  @override
  void dispose() {
    BluetoothService().dispose(); // Servisi sonlandır
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bluetooth Metadata")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Song Title: $songTitle', style: TextStyle(fontSize: 20)),
            Text('Artist: $songArtist', style: TextStyle(fontSize: 20)),
            Text('Album: $songAlbum', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
