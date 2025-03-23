import 'package:radior/models/radio_station.dart';

abstract class RadioState {
  final RadioStation radioStation;
  RadioState(this.radioStation);
}

class RadioLoading extends RadioState {
  RadioLoading(super.radioStation);
}

class RadioPlaying extends RadioState {
  RadioPlaying(super.radioStation);
}

class RadioPaused extends RadioState {
  RadioPaused(super.radioStation);
}