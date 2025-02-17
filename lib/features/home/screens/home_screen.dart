import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yodha_a/features/wallet/screens/wallat_screen.dart';
import 'package:yodha_a/providers/user_provider.dart';
import 'package:yodha_a/features/home/widgets/account_categories_box.dart';
import 'package:yodha_a/features/home/widgets/announcement_box.dart';
import 'package:yodha_a/features/home/widgets/carousel_image.dart';
import 'package:yodha_a/features/home/widgets/game_box.dart';
import 'package:yodha_a/features/services/cashfree_service.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instantiate your service
  final CashfreeService _cashfreeService = CashfreeService();

  // State variable for coinBalance. You can initialize with 0 or any default value.
  int coinBalance = 0;

  @override
  void initState() {
    super.initState();
    // fetchCategoryEvent();
    fetchUserWallet(); // Fetch wallet balance during initialization
  }

  Future<void> fetchUserWallet() async {
    final wallet = await _cashfreeService.getUserWalletBalance(context: context);
    if (wallet != null) {
      setState(() {
        coinBalance = wallet.coinBalance;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color(0xFF2B3A42), // Theme color remains the same
          elevation: 0,
          title: Stack(
            alignment: Alignment.center, // Ensures the Welcome Message is centered
            children: [
              // Centered Welcome Message
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome Back,",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    user.userName,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 246, 149, 46),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              // Left: Profile Image
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logo.jpg'),
                  radius: 20,
                ),
              ),
              // Right: Notifications & Coins
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        const Icon(Icons.notifications,
                            color: Colors.white, size: 28),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: const Text(
                              '0',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Wrap the coin balance container with InkWell for tapping
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WalletScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.currency_rupee_sharp,
                                color: Colors.yellow, size: 22),
                            const SizedBox(width: 5),
                            // Display the dynamic coinBalance
                            Text(
                              coinBalance.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnnouncementBox(
                message:
                    "Here is the small announcement which appears as per the directions."),
            // AccountCategoriesBox Widget
            AccountCategoriesBox(),
            const SizedBox(height: 10),
            CarouselImage(),
            const SizedBox(height: 10),
            GameBox()
          ],
        ),
      ),
    );
  }
}
