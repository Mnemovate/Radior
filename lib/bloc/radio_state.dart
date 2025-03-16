import 'package:radior/models/radio_station.dart';

abstract class RadioState {}

class RadioLoading extends RadioState {}

class RadioPlaying extends RadioState {
  final RadioStation station;
  RadioPlaying(this.station);
}

class RadioPaused extends RadioState {}