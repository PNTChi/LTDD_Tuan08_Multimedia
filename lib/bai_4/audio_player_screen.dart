import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Bai4AudioPlayerScreen extends StatefulWidget {
  const Bai4AudioPlayerScreen({super.key}); // Đã sửa lỗi Info

  @override
  State<Bai4AudioPlayerScreen> createState() => _Bai4AudioPlayerScreenState(); // Đã sửa lỗi Info
}

class _Bai4AudioPlayerScreenState extends State<Bai4AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  int _currentIndex = 0;
  bool _isPlaying = false;

  final List<String> _songs = ['sample1.mp3', 'sample2.mp3', 'sample3.mp3'];
  final List<String> _titles = ['Bài hát 1', 'Bài hát 2', 'Bài hát 3'];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => _isPlaying = state == PlayerState.playing);
    });
    _audioPlayer.onPlayerComplete.listen((_) => _nextSong());
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSong() => _audioPlayer.play(AssetSource('audios/${_songs[_currentIndex]}'));
  void _pauseSong() => _audioPlayer.pause();
  void _stopSong() => _audioPlayer.stop();

  void _changeSong(int step) {
    _stopSong();
    setState(() {
      _currentIndex = (_currentIndex + step) % _songs.length;
      if (_currentIndex < 0) _currentIndex = _songs.length - 1;
    });
    _playSong();
  }
  void _nextSong() => _changeSong(1);
  void _prevSong() => _changeSong(-1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bài 4: Audio Player')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_titles[_currentIndex], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.skip_previous, size: 40), onPressed: _prevSong),
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle, size: 50, color: Colors.blue),
                  onPressed: () => _isPlaying ? _pauseSong() : _playSong(),
                ),
                IconButton(icon: const Icon(Icons.stop_circle, size: 40, color: Colors.red), onPressed: _stopSong),
                IconButton(icon: const Icon(Icons.skip_next, size: 40), onPressed: _nextSong),
              ],
            ),
          ],
        ),
      ),
    );
  }
}