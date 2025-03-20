import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radior/bloc/radio_bloc.dart';
import 'package:radior/data/radio_stations.dart';
import 'package:radior/theme/color.dart';
import 'package:radior/views/onboarding.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Radior.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Radior.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => RadioBloc(stations),
        child: const Onboarding(),
      ),
    ),
  );
}