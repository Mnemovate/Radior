import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:radior/models/radio_station.dart';
import 'radio_event.dart';
import 'radio_state.dart';

class RadioBloc extends Bloc<RadioEvent, RadioState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  int currentStationIndex = 0;
  final List<RadioStation> stations;

  RadioBloc(this.stations)
    : super(
        RadioLoading(
          RadioStation(
            name: 'Jakarta - 92.0 fm',
            streamUrl:
                'https://cast1.my-control-panel.com/proxy/radioso1/stream',
            imageUrl:
                'https://www.sonora.co.id//assets/v2/images/network/jakarta.png',
            description: '...',
          ),
        ),
      ) {
    on<PlayPauseEvent>((event, emit) async {
      if (state is RadioPlaying) {
        await audioPlayer.pause();
        emit(RadioPaused(state.radioStation));
      } else {
        final station = stations[currentStationIndex];
        await audioPlayer.play(
          UrlSource(station.streamUrl),
          mode: PlayerMode.mediaPlayer,
        );
        emit(RadioPlaying(station));
      }
    });

    on<NextStationEvent>((event, emit) async {
      currentStationIndex = (currentStationIndex + 1) % stations.length;
      final station = stations[currentStationIndex];
      await audioPlayer.stop();
      await audioPlayer.play(
        UrlSource(station.streamUrl),
        mode: PlayerMode.mediaPlayer,
      );
      emit(RadioPlaying(station));
    });

    on<PreviousStationEvent>((event, emit) async {
      currentStationIndex =
          (currentStationIndex - 1 + stations.length) % stations.length;
      final station = stations[currentStationIndex];
      await audioPlayer.stop();
      await audioPlayer.play(
        UrlSource(station.streamUrl),
        mode: PlayerMode.mediaPlayer,
      );
      emit(RadioPlaying(station));
    });
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }

  String getImageUrl() {
    if (state is RadioPlaying ||
        state is RadioLoading ||
        state is RadioPaused) {
      return state.radioStation.imageUrl;
    } else {
      return 'https://www.sonora.co.id//assets/v2/images/network/surabaya.png';
    }
  }

  String getDescription() {
    if (state is RadioPlaying ||
        state is RadioLoading ||
        state is RadioPaused) {
      return state.radioStation.description;
    } else {
      return "...";
    }
  }

  String getDisplayName() {
    if (state is RadioPlaying) {
      return state.radioStation.name;
    } else if (state is RadioLoading) {
      return 'Memuat stasiun...';
    } else {
      return '';
    }
  }
}
