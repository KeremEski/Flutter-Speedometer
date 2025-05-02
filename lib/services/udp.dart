import 'dart:async';
import 'package:udp/udp.dart';

class UdpListener {
  late UDP receiver;
  final StreamController<Map<String, double>> _controller =
      StreamController.broadcast();

  Stream<Map<String, double>> get stream => _controller.stream;

  Future<void> startListening() async {
    receiver = await UDP.bind(Endpoint.any(port: const Port(5005)));

    receiver.asStream().listen((datagram) {
      if (datagram != null) {
        String message = String.fromCharCodes(datagram.data);
        // Mesajı ayrıştır (örn: "Speed: 120, RPM: 5400")
        RegExp regex = RegExp(r"Speed:\s*(\d+),\s*RPM:\s*(\d+)");
        Match? match = regex.firstMatch(message);

        if (match != null) {
          double speed = double.parse(match.group(1)!);
          double rpm = double.parse(match.group(2)!);

          _controller.add({"speed": speed, "rpm": rpm});
        }
      }
    });
  }

  void dispose() {
    receiver.close();
    _controller.close();
  }
}
