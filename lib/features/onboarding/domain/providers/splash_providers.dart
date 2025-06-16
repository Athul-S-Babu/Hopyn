import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to track if the app has been opened before
final isFirstLaunchProvider = StateProvider<bool>((ref) {
  // In a real app, this would check SharedPreferences or similar
  // For demo purposes, always return true
  return true;
});
