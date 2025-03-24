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
        shadowColor: Colors.transparent,
        surfaceTintColor: RadiorColor.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            'Radior',
            style: titleOnboarding.copyWith(
              color: RadiorColor.green,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 23),
            child: Text(
              'v1.0.0',
              style: descriptionOnboarding.copyWith(
                color: RadiorColor.black80,
              ),
            ),
          ),
        ],
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
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 220,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: RadiorColor.green80,
                          image: DecorationImage(
                            image: NetworkImage(bloc.getImageUrl()),
                            fit: BoxFit.cover,
                          ),
                    
                        ),
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
                                : SizedBox(),
                    
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: RadiorColor.green80,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/icons/chevron-left.svg',
                                width: 20,
                                color: state.radioStation == stations.first
                                    ? RadiorColor.black.withOpacity(0.2)
                                    : RadiorColor.black,
                              ),
                              onPressed: () {
                                state.radioStation == stations.first
                                ? ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Ini adalah stasiun pertama.',
                                        style: descriptionOnboarding.copyWith(
                                              
                                              color: RadiorColor.white,
                                            ),
                        
                                      ),
                                    ),
                                  )
                                : bloc.add(PreviousStationEvent());
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
                                    color: state.radioStation == stations.last
                                    ? RadiorColor.black.withOpacity(0.2)
                                    : RadiorColor.black,
                              ),
                              onPressed: () {
                                state.radioStation == stations.last
                                ? ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Ini adalah stasiun terakhir.',
                                        style: descriptionOnboarding.copyWith(                  
                                          color: RadiorColor.white,
                                        ),
                                      )
                                    ),
                                  )
                                : bloc.add(NextStationEvent());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                      
                      final isCurrentStation = index == bloc.currentStationIndex;
                      final isPlaying = state is RadioPlaying && isCurrentStation;
                      
                      return Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isCurrentStation ? RadiorColor.green : RadiorColor.black80.withOpacity(0.3),
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
                                      color: RadiorColor.white,
                                    ),
                                  ),
                                  Text(
                                    station.description,
                                    style: descriptionOnboarding.copyWith(
                                      fontSize: 14,
                                      color: RadiorColor.white,
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
                                color: RadiorColor.white,
                              ),
                              onPressed: () {
                                if (isCurrentStation) {
                                  bloc.add(PlayPauseEvent());
                                } else {
                                  bloc.currentStationIndex = index;
                                  bloc.add(PlayPauseEvent());
                                }
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