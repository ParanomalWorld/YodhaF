import 'package:flutter/material.dart';
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/features/home/screens/category_game_box_screen.dart';

class GameBox extends StatelessWidget {
  const GameBox({super.key});

  void navigateToCategoryGameBox(BuildContext context, String category) {
    Navigator.pushNamed(
      context,
      CategoryGameBoxScreen.routeName,
      arguments: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Enhanced padding for a premium look
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Esports Game Title
          const Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Text(
              'Esports Game',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),


          
          // Game Boxes Grid
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(), // Prevent internal scrolling
            shrinkWrap: true, // Allows it to take only the space it needs
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Three columns
              crossAxisSpacing: 12.0, // Increased spacing between columns
              mainAxisSpacing: 12.0, // Increased spacing between rows
              childAspectRatio: 1, // Square-shaped grid items
            ),
            itemCount: GlobalVariables.categoryImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => navigateToCategoryGameBox(
                  context,
                  GlobalVariables.categoryImages[index]['title']!,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          // Game Image
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              image: DecorationImage(
                                image: AssetImage(
                                    GlobalVariables.categoryImages[index]['image']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Red Title Strip
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red, // Red strip
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12.0),
                                  bottomRight: Radius.circular(12.0),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Text(
                                GlobalVariables.categoryImages[index]['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
