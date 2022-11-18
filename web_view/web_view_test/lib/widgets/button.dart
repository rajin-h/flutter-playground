import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultButton extends StatefulWidget {
  const DefaultButton(
      {super.key,
      required this.invert,
      required this.text,
      this.onTap,
      required this.color});

  final void Function()? onTap;
  final bool invert;
  final text;
  final Color color;

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        widget.onTap!();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: !widget.invert ? widget.color : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Text(
          widget.text,
          style: TextStyle(
              color: !widget.invert ? Colors.white : widget.color,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
