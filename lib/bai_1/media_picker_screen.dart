import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class Bai1MediaPickerScreen extends StatefulWidget {
  const Bai1MediaPickerScreen({super.key}); // Đã sửa lỗi Info

  @override
  State<Bai1MediaPickerScreen> createState() => _Bai1MediaPickerScreenState(); // Đã sửa lỗi Info
}

class _Bai1MediaPickerScreenState extends State<Bai1MediaPickerScreen> {
  File? _mediaFile;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();

  Future<void> _requestPermission(Permission permission) async {
    if (await permission.isDenied) await permission.request();
  }

  Future<void> _pickMedia(ImageSource source, bool isVideo) async {
    await _requestPermission(isVideo ? Permission.storage : Permission.photos);
    final XFile? pickedFile = await (isVideo
        ? _picker.pickVideo(source: source)
        : _picker.pickImage(source: source));

    if (pickedFile != null) {
      _processFile(File(pickedFile.path), isVideo);
    }
  }

  Future<void> _captureMedia(bool isVideo) async {
    await _requestPermission(Permission.camera);
    if (isVideo) await _requestPermission(Permission.microphone);

    final XFile? capturedFile = await (isVideo
        ? _picker.pickVideo(source: ImageSource.camera)
        : _picker.pickImage(source: ImageSource.camera));

    if (capturedFile != null) {
      _processFile(File(capturedFile.path), isVideo);
    }
  }

  void _processFile(File file, bool isVideo) {
    setState(() {
      _mediaFile = file;
      _videoController?.dispose();
      if (isVideo || file.path.endsWith('.mp4')) {
        _videoController = VideoPlayerController.file(_mediaFile!)
          ..initialize().then((_) {
            setState(() {});
            _videoController!.play();
          });
      } else {
        _videoController = null;
      }
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bài 1: Media Picker App')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20, width: double.infinity),
            _mediaFile == null
                ? Container(height: 200, alignment: Alignment.center, child: const Text('Chưa chọn ảnh/video.'))
                : (_videoController != null && _videoController!.value.isInitialized)
                ? AspectRatio(aspectRatio: _videoController!.value.aspectRatio, child: VideoPlayer(_videoController!))
                : Image.file(_mediaFile!, height: 300),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => _pickMedia(ImageSource.gallery, false), child: const Text('Chọn ảnh từ Gallery')),
            ElevatedButton(onPressed: () => _captureMedia(false), child: const Text('Chụp ảnh từ Camera')),
            ElevatedButton(onPressed: () => _pickMedia(ImageSource.gallery, true), child: const Text('Chọn video từ Gallery')),
            ElevatedButton(onPressed: () => _captureMedia(true), child: const Text('Quay video từ Camera')),
          ],
        ),
      ),
    );
  }
}