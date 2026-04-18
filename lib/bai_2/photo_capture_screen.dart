import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Bai2PhotoCaptureScreen extends StatefulWidget {
  const Bai2PhotoCaptureScreen({super.key}); // Đã sửa lỗi Info

  @override
  State<Bai2PhotoCaptureScreen> createState() => _Bai2PhotoCaptureScreenState(); // Đã sửa lỗi Info
}

class _Bai2PhotoCaptureScreenState extends State<Bai2PhotoCaptureScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _requestPermission(Permission permission) async {
    if (await permission.isDenied) await permission.request();
  }

  Future<void> _pickImage(ImageSource source) async {
    await _requestPermission(source == ImageSource.camera ? Permission.camera : Permission.photos);
    final XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      setState(() => _imageFile = File(file.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bài 2: Photo Capture & Preview')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile == null
                ? const Text('Chưa có ảnh nào.')
                : GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => FullScreenImage(imageFile: _imageFile!)
                ));
              },
              child: Image.file(_imageFile!, height: 300),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => _pickImage(ImageSource.gallery), child: const Text('Chọn ảnh (Gallery)')),
            ElevatedButton(onPressed: () => _pickImage(ImageSource.camera), child: const Text('Chụp ảnh (Camera)')),
          ],
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final File imageFile;
  const FullScreenImage({super.key, required this.imageFile}); // Đã sửa lỗi Info

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xem trước')),
      backgroundColor: Colors.black,
      body: Center(child: Image.file(imageFile)),
    );
  }
}