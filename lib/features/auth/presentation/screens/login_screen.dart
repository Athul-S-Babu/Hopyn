
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final success = await ref.read(authProvider.notifier).login(email, password);

    setState(() => _isLoading = false);

    if (success && mounted) {
      context.go('/home');
    } else if (mounted) {
      final errorMessage = ref.read(authProvider).errorMessage ?? 'Login failed. Please try again.';
      context.showSnackBar(errorMessage, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),

                // App Logo Placeholder
                Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: context.colorScheme.primary.withOpacity(0.1),
                    child: Image.asset('assets/images/hopyn_logo.png')
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Welcome to Hopyn',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.kYellow,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Ready for a Comfort Ride! ',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 10),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter Your Email Id',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your email';
                    if (!value.isValidEmail) return 'Please enter a valid email';
                    return null;
                  },
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.kYellow),

                  labelStyle: const TextStyle(color: AppColors.kPrimaryColor),
                  fillColor: AppColors.kWhiteShade,
                  hintStyle: const TextStyle(
                    color: AppColors.kBlackShade
                  ),

                ),


                const SizedBox(height: 20),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter Your Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your password';
                    if (value.length < AppConstants.passwordMinLength) {
                      return 'Password must be at least ${AppConstants.passwordMinLength} characters';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.kYellow),
                  labelStyle: const TextStyle(color: AppColors.kPrimaryColor),
                  hintStyle: const TextStyle(
                      color: AppColors.kBlackShade,
                  ),
                  fillColor: AppColors.kWhiteShade,
                ),

                const SizedBox(height: 4),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.showSnackBar('Password reset not implemented in this demo');
                    },
                    child: const Text('Forgot Password?',style: TextStyle(color: AppColors.kPrimaryColor),),
                  ),
                ),

                const SizedBox(height: 4),

                // Login Button
                CustomButton(
                  text: 'Sign In',
                  onPressed: _login,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 10),

                // Sign Up Prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.kPrimaryColor,
                      ),
                    ),

                    TextButton(
                      onPressed: () => context.go('/signup'),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
