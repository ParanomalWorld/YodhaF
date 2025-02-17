import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData? icon;
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final bool obscureText;
  final InputDecoration? decoration;

  const CustomTextField({
    super.key,
    this.icon,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.obscureText = false,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
      decoration: decoration ??
          InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            hintText: hintText,
            hintStyle: TextStyle(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: Colors.black54,
            prefixIcon: icon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 15, right: 8),
                    child: Icon(
                      icon,
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.8),
                    ),
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.cyanAccent,
                width: 2,
              ),
            ),
          ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your $hintText';
        }
        return null;
      },
    );
  }
}
