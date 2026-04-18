import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class Bai3VideoRecorderScreen extends StatefulWidget {
  const Bai3VideoRecorderScreen({super.key});

  @override
  State<Bai3VideoRecorderScreen> createState() => _Bai3VideoRecorderScreenState();
}

class _Bai3VideoRecorderScreenState extends State<Bai3VideoRecorderScreen> {
  File? _videoFile;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickVideo(ImageSource source) async {
    if (source == ImageSource.camera) {
      await Permission.camera.request();
      await Permission.microphone.request();
    } else {
      await Permission.photos.request();
    }

    final XFile? file = await _picker.pickVideo(source: source);
    if (file != null) {
      setState(() {
        _videoFile = File(file.path);
        _videoController?.dispose();
        _videoController = VideoPlayerController.file(_videoFile!)
          ..initialize().then((_) {
            setState(() {});
            _videoController!.play();
          });
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bài 3: Video Recorder')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20, width: double.infinity),
            (_videoController != null && _videoController!.value.isInitialized)
                ? AspectRatio(aspectRatio: _videoController!.value.aspectRatio, child: VideoPlayer(_videoController!))
                : Container(height: 200, alignment: Alignment.center, child: const Text('Chưa có video.')),
            const SizedBox(height: 10),
            if (_videoController != null)
              IconButton(
                iconSize: 50,
                icon: Icon(_videoController!.value.isPlaying ? Icons.pause_circle : Icons.play_circle),
                onPressed: () {
                  setState(() {
                    _videoController!.value.isPlaying ? _videoController!.pause() : _videoController!.play();
                  });
                },
              ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => _pickVideo(ImageSource.gallery), child: const Text('Chọn Video (Gallery)')),
            ElevatedButton(onPressed: () => _pickVideo(ImageSource.camera), child: const Text('Quay Video (Camera)')),
          ],
        ),
      ),
    );
  }
}