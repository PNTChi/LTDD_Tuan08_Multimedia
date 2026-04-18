import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Bai4AudioPlayerScreen extends StatefulWidget {
  const Bai4AudioPlayerScreen({super.key});

  @override
  State<Bai4AudioPlayerScreen> createState() => _Bai4AudioPlayerScreenState();
}

class _Bai4AudioPlayerScreenState extends State<Bai4AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final List<String> _songs = ['sample1.mp3', 'sample2.mp3', 'sample3.mp3'];
  final List<String> _titles = ['Bài hát 1', 'Bài hát 2', 'Bài hát 3'];
  final List<String> _artists = ['Ca sĩ A', 'Ca sĩ B', 'Ca sĩ C'];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) setState(() => _duration = newDuration);
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) setState(() => _position = newPosition);
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
      _position = Duration.zero;
    });
    _playSong();
  }

  void _nextSong() => _changeSong(1);
  void _prevSong() => _changeSong(-1);

  String _formatDuration(Duration d) {
    String minutes = d.inMinutes.toString().padLeft(2, '0');
    String seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('PLAY MUSIC', style: TextStyle(fontSize: 14, letterSpacing: 2, color: Colors.white70)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A148C), Color(0xFF121212)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white10,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: const Center(
                child: Icon(Icons.music_note_rounded, size: 100, color: Colors.white54),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              _titles[_currentIndex],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              _artists[_currentIndex],
              style: const TextStyle(fontSize: 16, color: Colors.white54),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 4,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 14),
                      activeTrackColor: Colors.pinkAccent,
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Colors.pinkAccent,
                    ),
                    child: Slider(
                      min: 0,
                      max: _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1.0,
                      value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble()),
                      onChanged: (value) {
                        final position = Duration(seconds: value.toInt());
                        _audioPlayer.seek(position);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(_position), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                        Text(_formatDuration(_duration), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: const Icon(Icons.stop_circle_outlined, size: 30, color: Colors.white54), onPressed: _stopSong),
                IconButton(icon: const Icon(Icons.skip_previous_rounded, size: 45, color: Colors.white), onPressed: _prevSong),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pinkAccent,
                  ),
                  child: IconButton(
                    iconSize: 50,
                    color: Colors.white,
                    icon: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                    onPressed: () => _isPlaying ? _pauseSong() : _playSong(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.skip_next_rounded, size: 45, color: Colors.white), onPressed: _nextSong),
                IconButton(icon: const Icon(Icons.shuffle, size: 30, color: Colors.white54), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}