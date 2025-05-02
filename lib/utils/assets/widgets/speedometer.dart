import 'package:car_multimedia/services/udp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class Speedometer extends StatefulWidget {
  const Speedometer({super.key, this.height, this.width});
  final double? height;
  final double? width;
  @override
  State<Speedometer> createState() => _SpeedometerState();
}

class _SpeedometerState extends State<Speedometer> {
  final FocusNode _focusNode = FocusNode();
  final UdpListener _udpListener = UdpListener();
  double speed = 0.0; // Hız değişkeni
  double maxSpeed = 160;
  double rpm = 0.0; // Hız değişkeni
  double maxRpm = 8000;
  bool _isProcessing = true;
  String receivedData = "Bekleniyor";
  String songTitle = "Boş";
  String songArtist = "Boş";
  String songAlbum = "Boş";

  @override
  void initState() {
    _hello();
    _udpListener.startListening(); // UDP dinleyicisini başlat
    _udpListener.stream.listen((data) {
      setState(() {
        if (!_isProcessing) {
          speed = data["speed"]!;
          rpm = data["rpm"]!;
          print(receivedData);
        }
      });
    });
    super.initState();
  }

  _hello() async {
    while (rpm < maxRpm && speed < maxSpeed) {
      await Future.delayed(const Duration(milliseconds: 5));
      setState(() {
        rpm += 52;
        speed += 1;
      });
    }

    while (rpm > 0 && speed > 0) {
      await Future.delayed(const Duration(milliseconds: 3));
      setState(() {
        rpm -= 52;
        speed -= 1;
      });
    }
    _isProcessing = false;
  }

  void _incraseSpeed() {
    if (speed >= maxSpeed) return;
    setState(() {
      speed += 10;
    });
  }

  void _decreaseSpeed() {
    if (speed <= 0) {
      setState(() {
        speed = 0;
      });
      return;
    }
    setState(() {
      speed -= 10;
    });
  }

  void _incraseRpm() {
    if (rpm >= maxRpm) return;
    setState(() {
      rpm += 100;
    });
  }

  void _decreaseRpm() {
    if (rpm <= 0) {
      setState(() {
        rpm = 0;
      });
      return;
    }
    setState(() {
      rpm -= 100;
    });
  }

  void _onKey(KeyEvent event) {
    if (_isProcessing) return;
    if (event is KeyRepeatEvent || event is KeyDownEvent) {
      final keysPressed = HardwareKeyboard.instance.logicalKeysPressed;

      if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
        _incraseSpeed();
      }
      if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
        _decreaseSpeed();
      }
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        _incraseRpm();
      }
      if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        _decreaseRpm();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = widget.height ?? 360;
    double width = widget.width ?? 700;

    return Scaffold(
      backgroundColor: Colors.black,
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _onKey,
        child: SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              _backPlate(),
              // RPM
              Positioned(
                top: height / 3.6,
                left: width / 3.72340426,
                child: _rpmNeedle(),
              ),
              // RPM Value
              Positioned(
                  top: height / 1.89473684,
                  left: width / 4.34782609,
                  child: _value(rpm)),
              // RPM Text
              Positioned(
                  top: height / 1.69014085,
                  left: width / 4.34782609,
                  child: _title("RPM")),
              // Hız göstergesi KMH
              Positioned(
                  top: height / 3.6,
                  right: width / 3.68421053,
                  child: _speedNeedle()),
              // KMH Value
              Positioned(
                  top: height / 1.89473684,
                  right: width / 4.29447853,
                  child: _value(speed)),
              // KM/H Text
              Positioned(
                top: height / 1.69014085,
                right: width / 4.32098765,
                child: _title("KM/H"),
              ),
              // Signals
              Positioned(
                  top: height / 9, left: width / 3.78378378, child: _signals())
            ],
          ),
        ),
      ),
    );
  }

  _backPlate() {
    return Positioned.fill(
      child: SizedBox(
        width: 727,
        height: 372,
        child: SvgPicture.asset("lib/assets/svg/backplate2.svg"),
      ),
    );
  }

  _rpmNeedle() {
    return Transform.rotate(
      alignment: Alignment.bottomCenter,
      angle: (rpm * 3.1416 / 5450) - 21.16,
      child: SizedBox(
        height: 100,
        child: SvgPicture.asset("lib/assets/svg/needle2.svg"),
      ),
    );
  }

  _value(value) {
    return SizedBox(
      width: 60,
      child: Center(
        child: Text(
          value.toStringAsFixed(0),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "Michroma",
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  _title(title) {
    return SizedBox(
      width: 60,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "Michroma",
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  _speedNeedle() {
    return Transform.rotate(
      alignment: Alignment.bottomCenter,
      angle: (speed * 3.1416 / 110.5) - 21.16,
      child: SizedBox(
        height: 100,
        child: SvgPicture.asset("lib/assets/svg/needle2.svg"),
      ),
    );
  }

  _signals() {
    return Row(
      children: [
        SvgPicture.asset(
          "lib/assets/svg/signal-left.svg",
          height: 24,
        ),
        const SizedBox(
          width: 280,
        ),
        SvgPicture.asset(
          "lib/assets/svg/signal-right.svg",
          height: 24,
        ),
      ],
    );
  }
}
