import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radior/bloc/radio_bloc.dart';
import 'package:radior/bloc/radio_event.dart';
import 'package:radior/bloc/radio_state.dart';

class RadioPlayerScreen extends StatelessWidget {
  const RadioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<RadioBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Radior'),
        centerTitle: true,
      ),
      body: BlocBuilder<RadioBloc, RadioState>(
        builder: (context, state) {
          String stationName = 'Memuat stasiun...';
          if (state is RadioPlaying) {
            stationName = state.station.name;
          } else if (state is RadioPaused) {
            stationName = 'Radio dijeda';
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(stationName, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: () => bloc.add(PreviousStationEvent()),
                  ),
                  IconButton(
                    icon: Icon(state is RadioPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () => bloc.add(PlayPauseEvent()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: () => bloc.add(NextStationEvent()),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}