import 'package:car_multimedia/services/system_control_service.dart';
import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  final String label; // "Ses" ya da "Parlaklık"
  final bool isVolume;

  const CustomSlider({super.key, required this.label, this.isVolume = false});

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double _value = 0.5;
  final _service = SystemControlService();

  @override
  void initState() {
    super.initState();
    _loadInitialValue();
  }

  Future<void> _loadInitialValue() async {
    final initial = widget.isVolume
        ? await _service.getVolume()
        : await _service.getBrightness();
    setState(() {
      _value = initial;
    });
  }

  void _onChanged(double value) {
    setState(() => _value = value);
    if (widget.isVolume) {
      _service.setVolume(value);
    } else {
      _service.setBrightness(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade800,
            trackHeight: 6,
            thumbColor: Colors.white,
            overlayColor: Colors.white.withOpacity(0.1),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(
            value: _value,
            min: 0,
            max: 1,
            onChanged: _onChanged,
          ),
        ),
      ],
    );
  }
}
