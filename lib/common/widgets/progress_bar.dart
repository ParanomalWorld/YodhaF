import 'package:flutter/material.dart';

class SpotsProgressBar extends StatelessWidget {
  final int totalSpots;
  final int filledSpots;

  const SpotsProgressBar({
    super.key,
    required this.totalSpots,
    required this.filledSpots,
  });

  @override
  Widget build(BuildContext context) {
    double progress = totalSpots > 0 ? filledSpots / totalSpots : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        SizedBox(
          width: 220, // Adjust width as needed
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 4), // Spacing between progress bar and texts
        // Row for the texts, aligned with the progress bar
        SizedBox(
          width: 220, // Match the width of the progress bar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Only ${totalSpots - filledSpots} spots left',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                '$filledSpots/$totalSpots',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
