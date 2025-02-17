import 'package:flutter/material.dart';

class SingleProduct extends StatelessWidget {
  final String image;
  final Color borderColor;

  
  const SingleProduct({
    super.key,
    required this.image,
    required this.borderColor, // Custom border color (orange/green)
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130, // Adjusted width
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 2.5), // Border Glow Effect
        boxShadow: [
          // ignore: deprecated_member_use
          BoxShadow(color: borderColor.withOpacity(0.6), blurRadius: 10),
        ],
      ),
      child: Stack(
        children: [
          // Background Image with dark overlay
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                // ignore: deprecated_member_use
                Colors.black.withOpacity(0.3), // Dark overlay effect
                BlendMode.darken,
              ),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.red),
              ),
            ),
          ),

          // FairPlay Badge
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.purple, // Background color
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 16), // Checkmark icon
                  const SizedBox(width: 5),
                  const Text(
                    'FairPlay : ON',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
