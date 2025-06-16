import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';

// Auth state
enum AuthStatus { initial, authenticated, unauthenticated, authenticating }

class AuthState {
  final User? user;
  final AuthStatus status;
  final String? errorMessage;

  AuthState({
    this.user,
    this.status = AuthStatus.initial,
    this.errorMessage,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isAuthenticating => status == AuthStatus.authenticating;

  AuthState copyWith({
    User? user,
    AuthStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  // Simulate login process
  Future<bool> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.authenticating);
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      // Simulate successful login with dummy data
      // In a real app, we would make an API call here
      final user = User.dummy();
      state = state.copyWith(
        user: user,
        status: AuthStatus.authenticated,
        errorMessage: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Failed to login. Please try again.',
      );
      return false;
    }
  }

  // Simulate signup process
  Future<bool> signup(String name, String email, String password, String phone) async {
    state = state.copyWith(status: AuthStatus.authenticating);
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      // Simulate successful signup with dummy data
      // In a real app, we would make an API call here
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      
      state = state.copyWith(
        user: user,
        status: AuthStatus.authenticated,
        errorMessage: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Failed to create account. Please try again.',
      );
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    state = state.copyWith(
      user: null,
      status: AuthStatus.unauthenticated,
      errorMessage: null,
    );
  }

  // Check auth status (e.g., at app start)
  Future<void> checkAuthStatus() async {
    // Simulate checking stored credentials
    await Future.delayed(const Duration(seconds: 1));
    
    // For demo purposes, we'll assume the user is not logged in initially
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }
}

// Providers
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

// Auth status provider
final authStatusProvider = Provider<AuthStatus>((ref) {
  return ref.watch(authProvider).status;
});
