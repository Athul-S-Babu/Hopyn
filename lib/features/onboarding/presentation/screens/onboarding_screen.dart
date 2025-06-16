import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'Welcome to Hopyn',
      description: 'Your ride, your way. Get to where you need to go with ease.',
      imagePath: AppAssets.onboarding1Svg,

    ),
    OnboardingItem(
      title: 'Choose Your Ride',
      description: 'Select from a variety of ride options to suit your needs and budget.',
      imagePath: AppAssets.onboarding2Svg,
    ),
    OnboardingItem(
      title: 'Track Your Journey',
      description: 'Follow your ride in real-time and share your trip details with loved ones.',
      imagePath: AppAssets.onboarding3Svg,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPage() {
    if (_currentPage < _onboardingItems.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.defaultAnimationDuration,
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    context.go('/login');
  }

  void _skipOnboarding() {
    _navigateToLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    'Skip',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.kPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingItems.length,
                itemBuilder: (context, index) {
                  final item = _onboardingItems[index];
                  return _OnboardingPage(item: item);
                },
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingItems.length,
                  (index) => _PageIndicator(
                    isActive: index == _currentPage,
                  ),
                ),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: CustomButton(

                        text: 'Previous',
                        onPressed: () {
                          _pageController.previousPage(
                            duration: AppConstants.defaultAnimationDuration,
                            curve: Curves.easeInOut,
                          );
                        },
                        buttonType: ButtonType.outline,
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: _currentPage == _onboardingItems.length - 1 ? 'Get Started' : 'Next',
                      onPressed: _onNextPage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const _OnboardingPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Onboarding image
          Expanded(
            flex: 2,
            child: Image.asset(
              item.imagePath,
              width: context.screenWidth * 0.8,
              fit: BoxFit.contain,
            ),
            // SvgPicture.network(
            //   // Placeholder SVG url
            //   placeholderBuilder: (context) => const Center(
            //     child: CircularProgressIndicator(),
            //   ),
            //   width: context.screenWidth * 0.8,
            // ),
          ),

          // Title and description
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: context.textTheme.displaySmall?.copyWith(
                    color: AppColors.kYellow,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  item.description,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.kPrimaryColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final bool isActive;

  const _PageIndicator({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: isActive ? 24.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: isActive ? AppColors.kPrimaryColor:AppColors.kPrimaryColor .withOpacity(0.3),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;

  OnboardingItem({
    required this.title,

    required this.description,
    required this.imagePath,
  });
}
