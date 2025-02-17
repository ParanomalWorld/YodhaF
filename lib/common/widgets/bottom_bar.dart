import 'package:flutter/material.dart';
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/features/account/screens/account_screen.dart';
import 'package:yodha_a/features/home/screens/home_screen.dart';
import 'package:badges/badges.dart' as custom_badge;
import 'package:yodha_a/features/wallet/screens/wallat_screen.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeScreen(),
    const WalletScreen(),
    //const CashfreePaymentScreen(),
    //const Center(child: Text('Wallat Page'),),
   // const Center(child: Text('Account Page'),),

     const AccountScreen(),
    // const CartScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final userCartLen = context.watch<UserProvider>().user.cart.length;

    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          // HOME
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.home,
              ),
            ),
            label: '',
          ),




          // WALLAT
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.wallet,
              ),
            ),
            label: '',
          ),




          // ACCOUNT
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: custom_badge.Badge(
                // badgeContent: Text(
                //   userCartLen.toString(),
                //   style: const TextStyle(color: Colors.white),
                // ),
                // badgeStyle: const custom_badge.BadgeStyle(
                //   badgeColor: Colors.red, // Adjust color as needed
                // ),
                child: const Icon(
                  Icons.account_box,
                ),
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}