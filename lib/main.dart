import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radior/bloc/radio_bloc.dart';
import 'package:radior/data/radio_stations.dart';
import 'package:radior/screens/onboarding_screen.dart';
import 'package:radior/themes/colors.dart';

void main() {
  runApp(Radior());
}

class Radior extends StatefulWidget {
  const Radior({super.key});

  @override
  State<Radior> createState() => _RadiorState();
}

class _RadiorState extends State<Radior> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setSystemUIOverlay();
  }

  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: RadiorColor.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: RadiorColor.white,
    ));
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    _setSystemUIOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: RadiorColor.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: RadiorColor.white,
          elevation: 0,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => RadioBloc(stations),
        child: SafeArea(child: const OnboardingScreen()),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}