import 'package:flutter/material.dart';
import 'package:radior/helpers/image_helper.dart';
import 'package:radior/themes/sizes.dart';
import 'package:radior/themes/texts.dart';
import 'package:radior/widgets/button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadiorLocal.svg(
              'onboarding.svg',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
            spaceHeight50,
            Text(
              'Streaming Radio Favoritmu',
              style: titleOnboarding,
            ),
            spaceHeigh20,
            Text(
              'Nikmati siaran langsung, musik, dan podcast eksklusif dalam satu aplikasi.',
              style: descriptionOnboarding,
            ),
            spaceHeight60,
            Button(
              text: 'Start using', 
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}