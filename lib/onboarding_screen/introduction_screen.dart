import 'package:bet_better/onboarding_screen/intro_component.dart';
import 'package:bet_better/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  int _currIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const IntroComponent(
      title: 'BetBetter',
      description:
          'Track your sports bets, manage your budget, and make smarter decisions.',
      imagePath: 'assets/logo.png',
    ),
    const IntroComponent(
      title: 'Responsible Gambling',
      description:
          'Stay in control of your betting. Set limits, track your spending, and track your winnings.',
      imagePath: 'assets/logo.png',
    ),
    const IntroComponent(
      title: 'Get Started',
      description: 'Set your goals and track your progress.',
      imagePath: 'assets/logo.png',
    ),
  ];

  void _skip() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() {
    if (_currIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      AuthService().signInAnon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int index) {
              setState(() {
                _currIndex = index;
              });
            },
            itemBuilder: (context, index) => _pages[index],
          ),
          _currIndex == _pages.length - 1
              ? const SizedBox.shrink()
              : Positioned(
                  bottom: 40,
                  left: 20,
                  child: TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () {
                      _skip();
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
          Positioned(
            bottom: 40,
            right: 20,
            child: TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: () {
                _nextPage();
              },
              child: Text(
                _currIndex == _pages.length - 1 ? 'Finish' : 'Next',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 53,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: const WormEffect(
                  activeDotColor: Colors.black,
                  dotHeight: 13,
                  dotWidth: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
