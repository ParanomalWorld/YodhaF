import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yodha_a/common/widgets/bottom_bar.dart';
import 'package:yodha_a/common/widgets/splash_screen.dart';
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/features/admin/screens/admin_screen.dart';
import 'package:yodha_a/features/auth/screens/auth_screen.dart';
import 'package:yodha_a/features/auth/services/auth_service.dart';
import 'package:yodha_a/features/rule_set/services/ruleset_service.dart';
import 'package:yodha_a/providers/user_provider.dart';
import 'package:yodha_a/router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        Provider<RulesetService>(
          create: (_) => RulesetService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await authService.getUserData(context); 
    
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YodhaX',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: isLoading
          ? const SplashScreen()
          : Provider.of<UserProvider>(context, listen: false).user.token.isNotEmpty
              ? (Provider.of<UserProvider>(context, listen: false).user.type == 'user'
                  ? const BottomBar()
                  : const AdminScreen())
              : const AuthScreen(),
    );
  }
}
