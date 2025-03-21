import 'package:flutter/material.dart';
import 'package:radior/helpers/image_helper.dart';
import 'package:radior/theme/text.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            SizedBox(height: 100),
            RadiorLocal.svg(
              'onboarding.svg',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 30),
            Text(
              'Radio Kesayanganmu',
              style: titleOnboarding,
            ),
            SizedBox(height: 20),
            Text(
              'Dengarkan musik & siaran favorit, kapan saja!',
              style: descriptionOnboarding,
            )
          ],
        ),
      ),
    );
  }
}