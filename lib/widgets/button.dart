import 'package:flutter/material.dart';
import 'package:radior/themes/colors.dart';
import 'package:radior/themes/texts.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const Button({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: RadiorColor.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: descriptionOnboarding.copyWith(
                  color: RadiorColor.white,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.arrow_forward, 
                color: RadiorColor.white,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}