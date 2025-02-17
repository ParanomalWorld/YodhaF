import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color glowColor;
  final Color? textColor;
  final Color? backgroundColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.glowColor = Colors.cyanAccent,
    this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: glowColor.withOpacity(0.8),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 55),
          backgroundColor: backgroundColor ?? Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: glowColor, width: 2),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor ?? glowColor,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: glowColor,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
