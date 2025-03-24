import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radior/bloc/radio_bloc.dart';
import 'package:radior/bloc/radio_event.dart';
import 'package:radior/bloc/radio_state.dart';
import 'package:radior/data/radio_stations.dart';
import 'package:radior/themes/colors.dart';
import 'package:radior/themes/sizes.dart';
import 'package:radior/themes/texts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Widget prepare() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RadioBloc>(
          create: (context) => RadioBloc(stations)..add(PlayPauseEvent()),
        ),
      ],
      child: const HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 116,
        backgroundColor: RadiorColor.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            'Radior',
            style: titleOnboarding.copyWith(
              color: RadiorColor.green,
            ),
          ),
        ),
      ),
      backgroundColor: RadiorColor.white,
      body: BlocBuilder<RadioBloc, RadioState>(
        builder: (context, state) {
          final bloc = context.read<RadioBloc>();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 280,
                    width: MediaQuery.of(context).size.width,
                    color: RadiorColor.green80,
                    child:
                        state is RadioLoading
                            ? Center(
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 10,
                                  valueColor: AlwaysStoppedAnimation(
                                    RadiorColor.green,
                                  ),
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                            )
                            : Image.network(
                              bloc.getImageUrl(),
                              fit: BoxFit.fitWidth,
                            ),
                  ),
                ),
                spaceHeight50,
                Text(
                  bloc.getDisplayName(),
                  style: descriptionOnboarding.copyWith(color: RadiorColor.black),
                ),
                spaceHeigh20,
                Text(
                  bloc.getDescription(),
                  style: descriptionOnboarding.copyWith(color: RadiorColor.black),
                ),
                spaceHeight50,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/chevron-left.svg',
                        width: 20,
                      ),
                      onPressed: () {
                        bloc.add(PreviousStationEvent());
                      },
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: RadiorColor.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          state is RadioPlaying 
                            ? 'assets/icons/pause.svg'
                            : 'assets/icons/play.svg',
                          width: 20,
                          color: RadiorColor.white,
                        ),
                        onPressed: () => bloc.add(PlayPauseEvent()),
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/chevron-right.svg',
                        width: 20,
                      ),
                      onPressed: () {
                        bloc.add(NextStationEvent());
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}