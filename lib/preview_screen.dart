import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("권한 요청 통과 테스트 스크린"),
      ),
    );
  }
}

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late CameraController cameraController;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    cameraController.buildPreview();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    } else {
      //TODO: 화면 전환 등 다음 작업을 위한 내용이 추가되어야함
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraPreview(cameraController);
  }
}
