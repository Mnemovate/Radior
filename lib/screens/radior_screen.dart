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
  bool isLoading = false;
  int currentStationIndex = 0;
  String errorMessage = '';
  
  final List<RadioStation> stations = [
    // URL alternatif yang lebih stabil untuk streaming RRI
    RadioStation(
      name: 'Pusat Pemberitaan',
      streamUrl: 'https://cdnjakartapro.rri.co.id/web-kbrn.mp3',
      imageUrl: 'https://www.rri.co.id/assets/v2/img/pro3.png',
      description: 'Pusat Pemberitaan',
    ),
    RadioStation(
      name: 'RRI Pro 1 Jakarta',
      streamUrl: 'https://cdnjakartapro.rri.co.id/web-jakartapro1.mp3',
      imageUrl: 'https://www.rri.co.id/assets/v2/img/pro1.png',
      description: 'Kanal Informasi dan Inspirasi',
    ),
    RadioStation(
      name: 'RRI Pro 2 Jakarta',
      streamUrl: 'https://cdnjakartapro.rri.co.id/web-jakartapro2.mp3',
      imageUrl: 'https://www.rri.co.id/assets/v2/img/pro2.png',
      description: 'Kanal Kreativitas dan Hiburan',
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Menambahkan listener untuk status pemutaran
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
        if (state == PlayerState.playing) {
          isLoading = false;
        }
      });
    });
    
    // // Tambahkan listener untuk error
    // audioPlayer.onPlayerError.listen((String error) {
    //   setState(() {
    //     isPlaying = false;
    //     isLoading = false;
    //     errorMessage = 'Gagal memutar audio: $error';
        
    //     // Tampilkan notifikasi error
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Gagal memainkan audio. Coba URL yang lain.'),
    //         backgroundColor: Colors.red,
    //       ),
    //     );
    //   });
      
    //   print('Error: $error'); // Log error untuk debugging
    // });
    
    // Preload URL pertama
    audioPlayer.setSourceUrl(stations[currentStationIndex].streamUrl);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playOrPause() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    
    try {
      if (isPlaying) {
        await audioPlayer.pause();
        setState(() {
          isLoading = false;
        });
      } else {
        // Gunakan metode dengan sourcePath yang lebih eksplisit
        await audioPlayer.play(UrlSource(stations[currentStationIndex].streamUrl), mode: PlayerMode.mediaPlayer);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
      print('Exception: $e'); // Log exception untuk debugging
    }
  }

  void nextStation() {
    setState(() {
      currentStationIndex = (currentStationIndex + 1) % stations.length;
      errorMessage = '';
    });
    
    // Hentikan pemutaran saat ini
    audioPlayer.stop();
    
    // Jika sedang memutar, langsung putar stasiun berikutnya
    if (isPlaying) {
      setState(() {
        isLoading = true;
      });
      audioPlayer.play(UrlSource(stations[currentStationIndex].streamUrl), mode: PlayerMode.mediaPlayer);
    }
  }

  void previousStation() {
    setState(() {
      currentStationIndex = (currentStationIndex - 1 + stations.length) % stations.length;
      errorMessage = '';
    });
    
    // Hentikan pemutaran saat ini
    audioPlayer.stop();
    
    // Jika sedang memutar, langsung putar stasiun sebelumnya
    if (isPlaying) {
      setState(() {
        isLoading = true;
      });
      audioPlayer.play(UrlSource(stations[currentStationIndex].streamUrl), mode: PlayerMode.mediaPlayer);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStation = stations[currentStationIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radio RRI'),
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
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: $errorMessage',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                            size: 80,
                            color: Colors.red,
                          ),
                          onPressed: playOrPause,
                        ),
                        if (isLoading)
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade300),
                            ),
                          ),
                      ],
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
                  isLoading ? "Memuat..." : isPlaying ? "Sedang Memutar..." : "Siap Diputar",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isLoading ? Colors.orange : isPlaying ? Colors.red : Colors.grey,
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