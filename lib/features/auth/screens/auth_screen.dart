import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:yodha_a/common/widgets/custom_button.dart';
import 'package:yodha_a/common/widgets/custom_textfield.dart';
import 'package:yodha_a/features/auth/services/auth_service.dart';

enum Auth { signin, signup }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _mobilNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
 

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    _mobilNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
      context: context,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      userName: _userNameController.text,
      mobileNumber:int.parse(_mobilNumberController.text) ,
      email: _emailController.text,
      password: _passwordController.text,
     
    );
  }

  void signInUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with Cyberpunk Theme
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/cyber_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: 380,
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    // ignore: deprecated_member_use
                    border: Border.all(color: Colors.cyanAccent.withOpacity(0.6), width: 2),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.cyanAccent.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated Toggle Buttons
                      ToggleButtons(
                        borderRadius: BorderRadius.circular(10),
                        isSelected: [_auth == Auth.signup, _auth == Auth.signin],
                        onPressed: (index) {
                          setState(() {
                            _auth = Auth.values[index];
                          });
                        },
                        selectedColor: Colors.cyanAccent,
                        color: Colors.white,
                        // ignore: deprecated_member_use
                        fillColor: Colors.cyanAccent.withOpacity(0.2),
                        borderWidth: 2,
                        borderColor: Colors.cyanAccent,
                        children: const [
                          Padding(padding: EdgeInsets.all(12.0), child: Text('Sign Up')),
                          Padding(padding: EdgeInsets.all(12.0), child: Text('Sign In')),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (_auth == Auth.signup) buildSignUpForm(),
                      if (_auth == Auth.signin) buildSignInForm(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSignUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          CustomTextField(controller: _firstNameController, hintText: 'First Name', icon: Icons.person),
          const SizedBox(height: 12),
           CustomTextField(controller: _lastNameController, hintText: 'Last Name', icon: Icons.person),
          const SizedBox(height: 12),
           CustomTextField(controller: _userNameController, hintText: 'Username', icon: Icons.verified_user_rounded),
          const SizedBox(height: 12),
           CustomTextField(controller: _mobilNumberController, hintText: 'Phone Number', icon: Icons.phone),
          const SizedBox(height: 12),
          CustomTextField(controller: _emailController, hintText: 'Email', icon: Icons.email),
          const SizedBox(height: 12),
          CustomTextField(controller: _passwordController, hintText: 'Create a Password', icon: Icons.lock, obscureText: true),
          const SizedBox(height: 20),
          CustomButton(
            text: 'SIGN UP',
            onTap: () {
              if (_signUpFormKey.currentState!.validate()) {
                signUpUser();
              }
            },
            glowColor: Color.fromARGB(255, 255, 163, 24),
          ),
        ],
      ),
    );
  }

  Widget buildSignInForm() {
    return Form(
      key: _signInFormKey,
      child: Column(
        children: [
          CustomTextField(controller: _emailController, hintText: 'Email', icon: Icons.email),
          const SizedBox(height: 12),
          CustomTextField(controller: _passwordController, hintText: 'Password', icon: Icons.lock, obscureText: true),
          const SizedBox(height: 20),
          CustomButton(
            text: 'SIGN IN',
            onTap: () {
              if (_signInFormKey.currentState!.validate()) {
                signInUser();
              }
            },
            glowColor: const Color.fromARGB(255, 255, 163, 24),
          ),
        ],
      ),
    );
  }
}
