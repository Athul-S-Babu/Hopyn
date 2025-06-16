// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter/services.dart';
//
// import '../../../../core/utils/constants.dart';
// import '../../../../core/utils/extensions.dart';
// import '../../../../core/widgets/custom_button.dart';
// import '../../../../core/widgets/custom_text_field.dart';
// import '../providers/auth_providers.dart';
//
// class SignupScreen extends ConsumerStatefulWidget {
//   const SignupScreen({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<SignupScreen> createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends ConsumerState<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _isLoading = false;
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _signup() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//
//     final name = _nameController.text.trim();
//     final phone = _phoneController.text.trim();
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();
//
//     final success = await ref.read(authProvider.notifier).signup(name, phone, email, password);
//
//     setState(() => _isLoading = false);
//
//     if (success && mounted) {
//       context.go('/home');
//     } else if (mounted) {
//       final errorMessage = ref.read(authProvider).errorMessage ?? 'Signup failed. Please try again.';
//       context.showSnackBar(errorMessage, isError: true);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kWhite,
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             backgroundColor: AppColors.kWhite,
//             pinned: true,
//             elevation: 0,
//             centerTitle: true,
//             systemOverlayStyle: SystemUiOverlayStyle.dark,
//             foregroundColor: AppColors.kPrimaryColor,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () => context.go('/login'),
//             ),
//             title: Text(
//               'Create Account',
//               style: context.textTheme.headlineMedium?.copyWith(color: AppColors.kYellow),
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.all(AppConstants.smallPadding),
//             sliver: SliverToBoxAdapter(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 12),
//                     Center(
//                       child: Text(
//                         'Please fill your details and\nget ready for a comfort ride.',
//                         textAlign: TextAlign.center,
//                         style: context.textTheme.bodyLarge?.copyWith(
//                           color: AppColors.kPrimaryColor.withOpacity(0.7),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     CustomTextField(
//                       controller: _nameController,
//                       label: 'Full Name',
//                       hint: 'Full Name',
//                       prefixIcon: const Icon(Icons.person_outline, color: AppColors.kYellow),
//                       hintStyle: const TextStyle(color: AppColors.kBlackShade),
//                       fillColor: AppColors.kWhiteShade,
//                       textCapitalization: TextCapitalization.words,
//                       keyboardType: TextInputType.name,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) return 'Please enter your name';
//                         return null;
//                       },
//                       labelStyle: const TextStyle(color: AppColors.kPrimaryColor),
//                     ),
//                     const SizedBox(height: 18),
//                     CustomTextField(
//                       controller: _phoneController,
//                       label: 'Phone Number',
//                       hint: 'Enter Your Phone Number',
//                       prefixIcon: const Icon(Icons.phone_iphone, color: AppColors.kYellow),
//                       hintStyle: const TextStyle(color: AppColors.kBlackShade),
//                       fillColor: AppColors.kWhiteShade,
//                       keyboardType: TextInputType.phone,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) return 'Please enter your phone number';
//                         if (!value.isValidPhone) return 'Please enter a valid phone number';
//                         return null;
//                       },
//                       labelStyle: const TextStyle(color: AppColors.kPrimaryColor),
//                     ),
//                     const SizedBox(height: 18),
//                     CustomTextField(
//                       controller: _emailController,
//                       label: 'Email',
//                       hint: 'Enter your email',
//                       prefixIcon: const Icon(Icons.email_outlined, color: AppColors.kYellow),
//                       hintStyle: const TextStyle(color: AppColors.kBlackShade),
//                       fillColor: AppColors.kWhiteShade,
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) return 'Please enter your email';
//                         if (!value.isValidEmail) return 'Please enter a valid email';
//                         return null;
//                       },
//                       labelStyle: const TextStyle(color: AppColors.kPrimaryColor),
//                     ),
//                     const SizedBox(height: 18),
//                     CustomTextField(
//                       controller: _passwordController,
//                       label: 'Password',
//                       hint: 'Enter Your Password',
//                       prefixIcon: const Icon(Icons.lock_outline, color: AppColors.kYellow),
//                       hintStyle: const TextStyle(color: AppColors.kBlackShade),
//                       fillColor: AppColors.kWhiteShade,
//                       obscureText: true,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) return 'Please enter your password';
//                         if (value.length < AppConstants.passwordMinLength) {
//                           return 'Password must be at least ${AppConstants.passwordMinLength} characters';
//                         }
//                         return null;
//                       },
//                       labelStyle: const TextStyle(color: AppColors.kPrimaryColor),
//                     ),
//                     const SizedBox(height: 18),
//                     CustomTextField(
//                       controller: _confirmPasswordController,
//                       label: 'Confirm Password',
//                       hint: 'Confirm Your Password',
//                       prefixIcon: const Icon(Icons.lock_outline, color: AppColors.kYellow),
//                       hintStyle: const TextStyle(color: AppColors.kBlackShade),
//                       fillColor: AppColors.kWhiteShade,
//                       obscureText: true,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) return 'Please confirm your password';
//                         if (value != _passwordController.text) return 'Passwords do not match';
//                         return null;
//                       },
//                       labelStyle: const TextStyle(color: AppColors.kPrimaryColor),
//                     ),
//                     const SizedBox(height: 32),
//                     CustomButton(
//                       text: 'Sign Up',
//                       onPressed: _signup,
//                       isLoading: _isLoading,
//                     ),
//                     const SizedBox(height: 24),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Already have an account?',
//                           style: context.textTheme.bodyMedium?.copyWith(color: AppColors.kYellow),
//                         ),
//                         TextButton(
//                           onPressed: () => context.go('/login'),
//                           child: const Text(
//                             'Sign In',
//                             style: TextStyle(color: AppColors.kPrimaryColor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/auth_providers.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final success = await ref.read(authProvider.notifier).signup(
      name,
      phone,
      email,
      password,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      context.go('/home');
    } else if (mounted) {
      final errorMessage =
          ref.read(authProvider).errorMessage ?? 'Signup failed. Please try again.';
      context.showSnackBar(errorMessage, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.largePadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.go('/login'),
                color: AppColors.kPrimaryColor,
                splashRadius: 20,
              ),
              const SizedBox(height: 16),
              Text(
                'Create Account',
                style: context.textTheme.headlineMedium?.copyWith(
                  color: AppColors.kYellow,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill in your details to get started',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.kPrimaryColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      hintStyle: const TextStyle(color: AppColors.kBlackShade),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: AppColors.kPrimaryColor.withOpacity(0.6),
                      ),
                      fillColor: AppColors.kWhiteShade,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      labelStyle: const TextStyle(color: AppColors.kPrimaryColor),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      hint: 'Enter your phone number',
                      hintStyle: const TextStyle(color: AppColors.kBlackShade),
                      prefixIcon: Icon(
                        Icons.phone_iphone,
                        color: AppColors.kPrimaryColor.withOpacity(0.6),
                      ),
                      fillColor: AppColors.kWhiteShade,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!value.isValidPhone) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      labelStyle: const TextStyle(color: AppColors.kPrimaryColor),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email address',
                      hintStyle: const TextStyle(color: AppColors.kBlackShade),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: AppColors.kPrimaryColor.withOpacity(0.6),
                      ),
                      fillColor: AppColors.kWhiteShade,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.isValidEmail) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      labelStyle: const TextStyle(color: AppColors.kPrimaryColor),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Create a password',
                      hintStyle: const TextStyle(color: AppColors.kBlackShade),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppColors.kPrimaryColor.withOpacity(0.6),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.kPrimaryColor.withOpacity(0.4),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        splashRadius: 20,
                      ),
                      fillColor: AppColors.kWhiteShade,
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < AppConstants.passwordMinLength) {
                          return 'Password must be at least ${AppConstants.passwordMinLength} characters';
                        }
                        return null;
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      labelStyle: const TextStyle(color: AppColors.kPrimaryColor),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      hint: 'Re-enter your password',
                      hintStyle: const TextStyle(color: AppColors.kBlackShade),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppColors.kPrimaryColor.withOpacity(0.6),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.kPrimaryColor.withOpacity(0.4),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        splashRadius: 20,
                      ),
                      fillColor: AppColors.kWhiteShade,
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      labelStyle: const TextStyle(color: AppColors.kPrimaryColor),
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'Create Account',
                      onPressed: _signup,
                      isLoading: _isLoading,
                      height: 56,

                     // borderRadius: 12,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.kPrimaryColor.withOpacity(0.7),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: Text(
                            'Sign In',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColors.kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}