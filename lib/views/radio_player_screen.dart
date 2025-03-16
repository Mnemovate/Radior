import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radior/bloc/radio_bloc.dart';
import 'package:radior/bloc/radio_event.dart';
import 'package:radior/bloc/radio_state.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RadioPlayerScreen extends StatelessWidget {
  const RadioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<RadioBloc>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            'Radior',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<RadioBloc, RadioState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    'https://www.sonora.co.id//assets/v2/images/network/surabaya.png',
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                state is RadioPlaying
                    ? state.station.name
                    : state is RadioPaused
                    ? 'Radio dijeda'
                    : 'Memuat stasiun...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                state is RadioPlaying ? state.station.description : "...",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20,
                ),
                child: LinearPercentIndicator(
                  lineHeight: 8.0,
                  percent: 0.9,
                  progressColor: Colors.green,
                  backgroundColor: Colors.grey.shade300,
                  barRadius: Radius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('03:35'), Text('03:50')],
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: () => bloc.add(PreviousStationEvent()),
                  ),
                  Icon(Icons.replay_10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        state is RadioPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () => bloc.add(PlayPauseEvent()),
                    ),
                  ),
                  Icon(Icons.forward_10),
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
