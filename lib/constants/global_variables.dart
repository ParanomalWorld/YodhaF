import 'package:flutter/material.dart';

String uri = 'https://8a35-205-254-174-252.ngrok-free.app';

class GlobalVariables {
   // COLORS
static const appBarGradient = LinearGradient(
  colors: [
    Color.fromARGB(255, 38, 67, 99), // Dark Navy Blue
    Color.fromARGB(255, 46, 60, 86), // Slightly lighter blue
  ],
  stops: [0.5, 1.0],
);

  static const secondaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const terturyColor = Color.fromRGBO(215, 214, 213, 1);
  static const backgroundColor = Color.fromARGB(255, 35, 40, 60);
  static const Color greyBackgroundCOlor = Color.fromARGB(255, 43, 58, 66);
  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Color.fromARGB(221, 238, 233, 233);

  // STATIC IMAGES
  static const List<String> carouselImages = [
   
    'https://i.pinimg.com/736x/05/c5/a8/05c5a8d81d7f26cc97e6fc9434f62987.jpg',
    'https://i.pinimg.com/736x/00/97/a3/0097a35575f6b8c41da5ab373e543995.jpg',
    'https://i.pinimg.com/736x/19/20/3e/19203e5631ace382683795c694d16ce8.jpg'
  ];

  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'FF SURVIVAL',
      'image': 'assets/images/surviaval.jpg',
    },
    {
      'title': 'FF FULL MAP',
      'image': 'assets/images/fullmap1.jpg',
    },
    {
      'title': 'FF FUL MAP 2',
      'image': 'assets/images/fullmap1.jpg',
    },
    {
      'title': 'FF CS-OLD',
      'image': 'assets/images/csold.jpg',
    },
    {
      'title': 'FF CS-NEW',
      'image': 'assets/images/csnew.jpg',
    },
     {
      'title': 'LONE WOLF',
      'image': 'assets/images/lonewolf.jpg',
    }, {
      'title': 'BATTLE G.',
      'image': 'assets/images/battleg.jpg',
    }, {
      'title': 'GTA',
      'image': 'assets/images/gta.jpg',
    },
  ];
  
}