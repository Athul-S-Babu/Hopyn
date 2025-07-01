

import 'package:flutter/material.dart';

class AppColors {
  static const kPrimaryColor = Color(0xFF062B40);
  static const kYellow=Color(0xFFFFD400);
  static const kBlack = Colors.black;
  static const kWhite = Colors.white;
  static const kWhiteShade = Color(0xffF6F6F6);
  static const kBlackBackground = Color(0xff101010);
  static const kBlackSecondary = Color(0xff272727);
  static const kGrey = Color(0xFFE0E0E0);
  static const kGreen = Color(0xFF4CAF50);
  static const kBlackShade= Color(0x42000000);


  static const kRed =Color(0xFFF44336);

}



class AppConstants {
  // App Dimensions
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double buttonHeight = 54.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  static const double inputBorderRadius = 8.0;

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration defaultAnimationDuration = Duration(milliseconds: 100);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Map Constants
  static const double defaultMapZoom = 15.0;

  // Mock Data - Only for UI demonstration
  static const initialCameraPosition = {
    'latitude': 37.7749,
    'longitude': -122.4194,
    'zoom': 14.0,
  };

  // Form Validation
  static const int passwordMinLength = 6;
  static final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );
  static final RegExp phoneRegExp = RegExp(
    r'^\+?[0-9]{10,12}$',
  );
}
