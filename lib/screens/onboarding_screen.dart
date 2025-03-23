import 'dart:async';
import 'package:flutter/material.dart';
import 'package:radior/helpers/image_helper.dart';
import 'package:radior/screens/home_screen.dart';
import 'package:radior/themes/colors.dart';
import 'package:radior/themes/sizes.dart';
import 'package:radior/themes/texts.dart';
import 'package:radior/widgets/button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;
  final int _totalPages = 3;
  final Duration _slideDuration = const Duration(seconds: 5);
  double _progress = 0.0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: _slideDuration,
    );
    
    _animationController.addListener(() {
      setState(() {
        _progress = _animationController.value;
      });
      
      // When animation completes, move to next page
      if (_animationController.isCompleted) {
        if (_currentPage < _totalPages - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          // On last page, you might want to navigate to home or restart
          // For now, we'll just stop the timer
          _timer.cancel();
        }
      }
    });
    
    // Start the initial animation
    _startTimerForPage();
  }

  void _startTimerForPage() {
    _animationController.reset();
    _animationController.forward();
  }

  // Skip to the last onboarding screen
  void _skipToLastOnboarding() {
    _animationController.stop();
    _pageController.animateToPage(
      _totalPages - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // Restart the timer for the last page
    _startTimerForPage();
  }

  void _navigateToHomeScreen() {
    // Stop the animation
    _animationController.stop();
    
    // Navigate to the home screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen.prepare()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
              _startTimerForPage();
            },
            children: [
              // First onboarding screen
              _buildOnboardingPage(
                imageName: 'test3.svg',
                title: 'Streaming Radio Favoritmu',
                description: 'Nikmati siaran langsung, musik, dan podcast eksklusif dalam satu aplikasi.',
                buttonText: 'Lanjutkan',
                onPressed: () {
                  _animationController.reset();
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              
              // Second onboarding screen
              _buildOnboardingPage(
                imageName: 'test3.svg',
                title: 'Temukan Channel Favorit',
                description: 'Jelajahi ratusan stasiun radio lokal dan internasional dengan kualitas audio terbaik.',
                buttonText: 'Selanjutnya',
                onPressed: () {
                  _animationController.reset();
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              
              // Third onboarding screen
              _buildOnboardingPage(
                imageName: 'test3.svg',
                title: 'Dengarkan Dimana Saja',
                description: 'Akses siaran radio kapan saja dan dimana saja, bahkan tanpa koneksi internet.',
                buttonText: 'Mulai Sekarang',
                onPressed: () {
                  _navigateToHomeScreen();
                },
              ),
            ],
          ),

          // Progress indicators at top
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: List.generate(
                  _totalPages,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: 6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: index < _currentPage 
                              ? 1.0 
                              : (index == _currentPage ? _progress : 0.0),
                          backgroundColor: RadiorColor.green80,
                          valueColor: AlwaysStoppedAnimation<Color>(RadiorColor.green),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Skip button
          Positioned(
            top: 80,
            right: 23,
            child: TextButton(
              style: TextButton.styleFrom(
                enabledMouseCursor: SystemMouseCursors.click,
                backgroundColor: RadiorColor.white,
                minimumSize: Size.zero,
                overlayColor: RadiorColor.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                elevation: 0,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                animationDuration: Duration(milliseconds: 500),
              ),
              onPressed: () {
                _skipToLastOnboarding();
              },
              child: Text(
                'Skip',
                style: descriptionOnboarding,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String imageName,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RadiorLocal.svg(
            imageName,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          ),
          spaceHeight50,
          Text(
            title,
            style: titleOnboarding,
            textAlign: TextAlign.center,
          ),
          spaceHeigh20,
          Text(
            description,
            style: descriptionOnboarding,
            textAlign: TextAlign.center,
          ),
          spaceHeight60,
          Button(
            text: buttonText,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}