import 'package:flutter/material.dart';
import 'package:yodha_a/constants/global_variables.dart';

class HomeContactusScreen extends StatefulWidget {

  static const String routeName = "/home-contactus";
  const HomeContactusScreen({super.key});

  @override
  State<HomeContactusScreen> createState() => _HomeContactusScreenState();
}

class _HomeContactusScreenState extends State<HomeContactusScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: PreferredSize(
              
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title:const Text('Contact Us', 
          style: TextStyle(
          
            color: Colors.black),)
        ),
      ),












    );
  }
}
 