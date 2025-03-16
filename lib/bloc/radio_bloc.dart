import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:radior/models/radio_station.dart';
import 'radio_event.dart';
import 'radio_state.dart';

class RadioBloc extends Bloc<RadioEvent, RadioState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  int currentStationIndex = 0;
  final List<RadioStation> stations;

  RadioBloc(this.stations) : super(RadioLoading()) {
    on<PlayPauseEvent>((event, emit) async {
      if (state is RadioPlaying) {
        await audioPlayer.pause();
        emit(RadioPaused());
      } else {
        final station = stations[currentStationIndex];
        await audioPlayer.play(UrlSource(station.streamUrl), mode: PlayerMode.mediaPlayer);
        emit(RadioPlaying(station));
      }
    });

    on<NextStationEvent>((event, emit) async {
      currentStationIndex = (currentStationIndex + 1) % stations.length;
      final station = stations[currentStationIndex];
      await audioPlayer.stop();
      await audioPlayer.play(UrlSource(station.streamUrl), mode: PlayerMode.mediaPlayer);
      emit(RadioPlaying(station));
    });

    on<PreviousStationEvent>((event, emit) async {
      currentStationIndex = (currentStationIndex - 1 + stations.length) % stations.length;
      final station = stations[currentStationIndex];
      await audioPlayer.stop();
      await audioPlayer.play(UrlSource(station.streamUrl), mode: PlayerMode.mediaPlayer);
      emit(RadioPlaying(station));
    });
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}