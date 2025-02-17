import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:yodha_a/common/widgets/bottom_bar.dart';
import 'package:yodha_a/features/admin/screens/admin_screen.dart';
import 'package:yodha_a/features/auth/screens/auth_screen.dart';
import 'package:yodha_a/features/auth/services/auth_service.dart';
import 'package:yodha_a/providers/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService authService = AuthService();
  bool hasInternet = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    hasInternet = await _checkInternet();

    if (!hasInternet) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      // ignore: use_build_context_synchronously
      await authService.getUserData(context).timeout(const Duration(seconds: 8));
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });

      // Move to the correct screen after splash
      Future.microtask(() => _navigate());
    }
  }

  Future<bool> _checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    // ignore: unrelated_type_equality_checks
    return connectivityResult != ConnectivityResult.none;
  }

  void _navigate() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Widget nextScreen;

    if (userProvider.user.token.isNotEmpty) {
      nextScreen = userProvider.user.type == 'user'
          ? const BottomBar()
          : const AdminScreen();
    } else {
      nextScreen = const AuthScreen();
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
      (route) => false, // Clears the navigation stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/splash_image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : hasInternet
              ? const Center(child: CircularProgressIndicator())
              : _noInternetUI(),
    );
  }

  Widget _noInternetUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 60, color: Colors.red),
          const SizedBox(height: 10),
          const Text(
            "No Internet Connection",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _initializeAuth,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
