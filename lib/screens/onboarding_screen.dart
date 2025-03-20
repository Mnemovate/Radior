import 'package:flutter/material.dart';
import 'package:radior/helpers/image_helper.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RadiorLocal.svg(
            'onboarding.svg',
          ),
          Text('Onboarding Screen'),
        ],
      ),
    );
  }
}