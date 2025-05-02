import 'package:car_multimedia/utils/assets/widgets/upper_bar.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  const Layout({super.key, required this.child});
  final Widget child;
  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const UpperBar(),
        Expanded(
          child: widget.child,
        ),
      ],
    );
  }
}
