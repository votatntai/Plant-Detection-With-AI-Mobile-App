import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  final CameraController controller;

  CameraScreen({required this.controller});

  @override
  _CameraScreenState createState() => _CameraScreenState(controller: controller);
}

class _CameraScreenState extends State<CameraScreen> {
  final CameraController controller;
  File? capturedImage;

  _CameraScreenState({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Màn hình Camera'),
      ),
      body: Center(
        child: Column(
          children: [
            // Widget để hiển thị hình ảnh từ camera
            CameraPreview(controller),
            InkWell(
              onTap: () async {
                // Chụp ảnh
                final XFile? picture = await takePicture(controller);
                if (picture != null) {
                  setState(() {
                    // Gán ảnh đã chụp vào biến capturedImage
                    capturedImage = File(picture.path);
                  });

                  // Chuyển đến màn hình xem ảnh
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewScreen(imageFile: capturedImage!),
                    ),
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.all(32.0), // Padding xung quanh nút
              child: Container(
                width: 60.0, // Điều chỉnh kích thước nút
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue, // Điều chỉnh màu sắc nút tùy ý
                ),
                child: Center(
                  child: Icon(
                    Icons.camera,
                    color: Colors.white, // Điều chỉnh màu sắc biểu tượng tùy ý
                    size: 32.0, // Điều chỉnh kích thước biểu tượng tùy ý
                  ),
                ),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<XFile?> takePicture(CameraController controller) async {
    try {
      return await controller.takePicture();
    } catch (e) {
      print('Lỗi khi chụp ảnh: $e');
      return null;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ImageViewScreen extends StatelessWidget {
  final File imageFile;

  ImageViewScreen({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xem ảnh'),
      ),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}
