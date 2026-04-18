import 'package:flutter/material.dart';
import 'bai_1/media_picker_screen.dart';
import 'bai_2/photo_capture_screen.dart';
import 'bai_3/video_recorder_screen.dart';
import 'bai_4/audio_player_screen.dart';

void main() {
  runApp(const MyApp()); // Thêm const
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Thêm constructor có chứa key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài Tập Tuần 08',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const MainMenuScreen(), // Thêm const
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key}); // Thêm constructor có chứa key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách Bài tập Tuần 08'), // Thêm const
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Các màn hình con gọi ra cũng được thêm const
            _buildMenuButton(context, 'Bài 1: Media Picker', const Bai1MediaPickerScreen()),
            const SizedBox(height: 15),
            _buildMenuButton(context, 'Bài 2: Photo Capture', const Bai2PhotoCaptureScreen()),
            const SizedBox(height: 15),
            _buildMenuButton(context, 'Bài 3: Video Recorder', const Bai3VideoRecorderScreen()),
            const SizedBox(height: 15),
            _buildMenuButton(context, 'Bài 4: Audio Player', const Bai4AudioPlayerScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, Widget screen) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: const Size(250, 50)), // Thêm const
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
      child: Text(title, style: const TextStyle(fontSize: 16)), // Thêm const
    );
  }
}