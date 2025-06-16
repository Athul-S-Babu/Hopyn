import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // Theme extensions
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Size extensions
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Padding extensions
  EdgeInsets get defaultPadding => const EdgeInsets.all(16.0);
  EdgeInsets get horizontalPadding => const EdgeInsets.symmetric(horizontal: 16.0);
  EdgeInsets get verticalPadding => const EdgeInsets.symmetric(vertical: 16.0);

  // Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(this).colorScheme.error : Theme.of(this).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// String extensions
extension StringExtensions on String {
  bool get isValidEmail {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(this);
  }

  bool get isValidPhone {
    return RegExp(r'^\+?[0-9]{10,12}$').hasMatch(this);
  }

  bool get isValidPassword {
    return length >= 6;
  }
}

// Double extensions
extension DoubleExtensions on double {
  String get toCurrency {
    return '\$$this';
  }

  String get toDistance {
    return '${toStringAsFixed(1)} km';
  }

  String get toTime {
    int minutes = round();
    if (minutes < 60) {
      return '$minutes min';
    } else {
      int hours = minutes ~/ 60;
      int remainingMinutes = minutes % 60;
      return '$hours hr ${remainingMinutes > 0 ? '$remainingMinutes min' : ''}';
    }
  }
}
