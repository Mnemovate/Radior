import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class RadioScreen extends StatelessWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const RadioPlayerScreen(),
    );
  }
}

class RadioStation {
  final String name;
  final String streamUrl;
  final String imageUrl;

  RadioStation({
    required this.name,
    required this.streamUrl,
    required this.imageUrl,
  });
}

class RadioPlayerScreen extends StatefulWidget {
  const RadioPlayerScreen({Key? key}) : super(key: key);

  @override
  _RadioPlayerScreenState createState() => _RadioPlayerScreenState();
}

class _RadioPlayerScreenState extends State<RadioPlayerScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int currentStationIndex = 0;
  
  final List<RadioStation> stations = [
    RadioStation(
      name: 'Radio Prambors',
      streamUrl: 'https://23743.live.streamtheworld.com/PRAMBORS_FM.mp3',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/id/5/55/Prambors.png',
    ),
    RadioStation(
      name: 'Radio RDI',
      streamUrl: 'https://stream.radiojar.com/4ywdgup5mv8uv',
      imageUrl: 'https://static.wikia.nocookie.net/logopedia/images/4/44/RDI_logo.jpg',
    ),
    RadioStation(
      name: 'Radio Hard Rock FM',
      streamUrl: 'https://23743.live.streamtheworld.com/HARD_ROCK_FM.mp3',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/9/94/Hard_Rock_FM_%282021%29.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playOrPause() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(UrlSource(stations[currentStationIndex].streamUrl));
    }
  }

  void nextStation() {
    setState(() {
      currentStationIndex = (currentStationIndex + 1) % stations.length;
    });
    if (isPlaying) {
      audioPlayer.stop();
      audioPlayer.play(UrlSource(stations[currentStationIndex].streamUrl));
    }
  }

  void previousStation() {
    setState(() {
      currentStationIndex = (currentStationIndex - 1 + stations.length) % stations.length;
    });
    if (isPlaying) {
      audioPlayer.stop();
      audioPlayer.play(UrlSource(stations[currentStationIndex].streamUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStation = stations[currentStationIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radior'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: NetworkImage(currentStation.imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 10.0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              currentStation.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 40),
                  onPressed: previousStation,
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    size: 60,
                    color: Colors.blue,
                  ),
                  onPressed: playOrPause,
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 40),
                  onPressed: nextStation,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}