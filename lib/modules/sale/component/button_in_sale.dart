import 'package:flutter/material.dart';

class ButtonInSale extends StatelessWidget {
  const ButtonInSale({
    Key? key,
    required this.text,
    required this.bgColor,
    required this.frColor,
    required this.bdColor,
    this.textSize = 18,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final Color bgColor, frColor, bdColor;
  final double textSize;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: frColor,
            side: BorderSide(
              color: bdColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
          ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.bold),
        )
      ),
    );
  }
}
