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
                    height: 220,
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
                spaceHeight40,
                Text(
                  bloc.getDisplayName(),
                  style: descriptionOnboarding.copyWith(
                    fontWeight: FontWeight.w700,
                    color: RadiorColor.black,
                  ),
                ),
                spaceHeight20,
                Text(
                  bloc.getDescription(),
                  style: descriptionOnboarding.copyWith(
                    fontSize: 14,
                    color: RadiorColor.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                spaceHeight40,
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
                spaceHeight40,
                Row(
                  children: [
                    Text(
                      "Daftar Saluran",
                      style: titleOnboarding,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                spaceHeight20,
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: stations.length,
                    itemBuilder: (context, index) {
                      final station = stations[index];
                      
                      final isPlaying = true; // jika state saat ini sama
                      
                      return Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isPlaying ? RadiorColor.green : RadiorColor.green80,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        margin: EdgeInsets.only(bottom: (stations.length - 1) == index ? 0 : 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                station.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.music_note, color: Colors.teal),
                                  );
                                },
                              ),
                            ),
                            spaceWidth20,
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    station.name,
                                    style: descriptionOnboarding.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: RadiorColor.black,
                                    ),
                                  ),
                                  Text(
                                    station.description,
                                    style: descriptionOnboarding.copyWith(
                                      fontSize: 14,
                                      color: RadiorColor.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ),
                            IconButton(
                              icon: SvgPicture.asset(
                                isPlaying ? 'assets/icons/pause.svg' : 'assets/icons/play.svg',
                                width: 20,
                              ),
                              onPressed: () {
                                // isPlaying play or pause
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}