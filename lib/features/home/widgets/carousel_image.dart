import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:yodha_a/constants/global_variables.dart';

class CarouselImage extends StatefulWidget {
  const CarouselImage({super.key});

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  int _currentIndex = 0; // To track the current slide index

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Add padding
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // Increased corner radius
            child: CarouselSlider(
              items: GlobalVariables.carouselImages.map(
                (i) {
                  return Builder(
                    builder: (BuildContext context) => SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9, // Increased width
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Consistent corner radius
                        child: Image.network(
                          i,
                          fit: BoxFit.cover,
                          height: 160, // Slightly increased height
                          width: MediaQuery.of(context).size.width * 0.9, // Ensure width consistency
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                height: 160, // Slightly increased height
                autoPlay: true, // Enables automatic swiping
                autoPlayInterval: const Duration(seconds: 3), // Time for each swipe
                autoPlayAnimationDuration: const Duration(milliseconds: 800), // Smooth swipe animation
                autoPlayCurve: Curves.easeInOut, // Smooth swipe animation
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index; // Update the current index
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8), // Space between carousel and dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: GlobalVariables.carouselImages.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => {}, // Add any specific action on dot tap if required
              child: Container(
                width: _currentIndex == entry.key ? 10 : 8, // Highlight the current dot
                height: _currentIndex == entry.key ? 10 : 8, // Highlight the current dot
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? Colors.red // Highlight color
                      : Colors.grey, // Inactive dot color
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
