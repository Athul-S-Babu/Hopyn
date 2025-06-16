import 'package:flutter_riverpod/flutter_riverpod.dart';

// Search history provider
final searchHistoryProvider = StateProvider<List<String>>((ref) {
  // In a real app, we would fetch this from local storage
  return [
    'San Francisco Airport (SFO)',
    'Golden Gate Park',
    'Fisherman\'s Wharf',
    'Union Square',
    'Chinatown',
  ];
});

// Add a search query to history
void addToSearchHistory(WidgetRef ref, String query) {
  if (query.trim().isEmpty) return;
  
  final currentHistory = ref.read(searchHistoryProvider);
  
  // Remove if already exists to avoid duplicates
  final filteredHistory = currentHistory.where((item) => item != query).toList();
  
  // Add to the beginning
  filteredHistory.insert(0, query);
  
  // Keep only the last 10 entries
  final updatedHistory = filteredHistory.take(10).toList();
  
  ref.read(searchHistoryProvider.notifier).state = updatedHistory;
}

// Clear search history
void clearSearchHistory(WidgetRef ref) {
  ref.read(searchHistoryProvider.notifier).state = [];
}
