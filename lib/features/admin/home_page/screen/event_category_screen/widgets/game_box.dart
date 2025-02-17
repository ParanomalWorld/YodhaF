import 'package:flutter/material.dart';
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/features/admin/home_page/screen/event_category_screen/screen/admin_category_game_box_screen.dart';


class GameBox extends StatelessWidget {
  const GameBox({super.key});

  void navigateToCategoryGameBox(BuildContext context, String category) {
    Navigator.pushNamed(
      context,
      AdminCategoryGameBoxScreen.routeName,
      arguments: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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

          // Scrollable Game Card List
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: GlobalVariables.categoryImages.length,
            itemBuilder: (context, index) {
              final category = GlobalVariables.categoryImages[index];

              return GestureDetector(
                onTap: () => navigateToCategoryGameBox(
                  context,
                  category['title']!,
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  height: 150, // Increased height for a premium look
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0), // Reduced corner radius
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.1), // Glass effect
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Left Side - Game Image
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                        child: Image.asset(
                          category['image']!,
                          width: 120, // Fixed width for consistency
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Right Side - Game Info
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                category['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Trending game mode',
                                style: TextStyle(
                                  // ignore: deprecated_member_use
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Ranking Badge (Top Right)
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            "#${index + 1}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
