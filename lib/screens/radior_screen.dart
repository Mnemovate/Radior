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
  final String description;

  RadioStation({
    required this.name,
    required this.streamUrl,
    required this.imageUrl,
    required this.description,
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
      name: 'Pusat Pemberitaan',
      streamUrl: 'https://stream-node0.rri.co.id/streaming/14/9014/kbrn.mp3',
      imageUrl: 'https://www.rri.co.id/assets/v2/img/pro3.png',
      description: 'Pusat Pemberitaan',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade100, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(currentStation.imageUrl),
                    fit: BoxFit.contain,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                currentStation.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                currentStation.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red.shade700,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, size: 40),
                    onPressed: previousStation,
                  ),
                  const SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.shade50,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        size: 80,
                        color: Colors.red,
                      ),
                      onPressed: playOrPause,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.skip_next, size: 40),
                    onPressed: nextStation,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  isPlaying ? "Sedang Memutar..." : "Siap Diputar",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isPlaying ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}