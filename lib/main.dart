import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radior/bloc/radio_bloc.dart';
import 'package:radior/bloc/radio_event.dart';
import 'package:radior/data/radio_stations.dart';
import 'package:radior/views/radio_player_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(backgroundColor: Colors.white),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => RadioBloc(stations)..add(PlayPauseEvent()),
        child: const RadioPlayerScreen(),
      ),
    ),
  );
}