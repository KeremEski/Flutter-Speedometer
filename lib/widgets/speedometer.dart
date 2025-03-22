import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class Speedometer extends StatefulWidget {
  const Speedometer({super.key});

  @override
  State<Speedometer> createState() => _SpeedometerState();
}

class _SpeedometerState extends State<Speedometer> {
  final FocusNode _focusNode = FocusNode();
  double speed = 0.0; // Hız değişkeni
  double maxSpeed = 160;
  double rpm = 0.0; // Hız değişkeni
  double maxRpm = 8000;

  @override
  void initState() {
    _hello();
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
  }

  void _incraseSpeed() {
    if (speed >= maxSpeed) return;
    setState(() {
      speed += 10;
    });
    print(speed);
  }

  void _decreaseSpeed() {
    if (speed <= 0) return;
    setState(() {
      speed -= 10;
    });
    print(speed);
  }

  void _incraseRpm() {
    if (rpm >= maxRpm) return;
    setState(() {
      rpm += 100;
    });
  }

  void _decreaseRpm() {
    if (rpm <= 0) return;
    setState(() {
      rpm -= 100;
    });
  }

  void _onKey(KeyEvent event) {
    if (event is KeyRepeatEvent || event is KeyDownEvent) {
      // W tuşuna basıldığında hız arttır
      if (event.logicalKey == LogicalKeyboardKey.keyW) {
        _incraseSpeed();
      }
      // S tuşuna basıldığında hız azalt
      else if (event.logicalKey == LogicalKeyboardKey.keyS) {
        _decreaseSpeed();
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _incraseRpm();
      }
      // S tuşuna basıldığında hız azalt
      else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _decreaseRpm();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _onKey,
        child: Container(
          height: 360,
          width: 700,
          color: Colors.black,
          child: Stack(
            children: [
              _backPlate(),
              // RPM
              Positioned(
                top: 100,
                left: 188,
                child: _rpmNeedle(),
              ),
              // RPM Value
              Positioned(top: 190, left: 161, child: _value(rpm)),
              // RPM Text
              Positioned(top: 213, left: 161, child: _title("RPM")),
              // Hız göstergesi KMH
              Positioned(top: 100, right: 188, child: _speedNeedle()),
              // KMH Value
              Positioned(top: 190, right: 163, child: _value(speed)),
              // KM/H Text
              Positioned(
                top: 213,
                right: 162,
                child: _title("KM/H"),
              ),
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
}
