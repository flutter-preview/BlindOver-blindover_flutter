import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen>
    with WidgetsBindingObserver {
  CameraController? cameraController;
  List<CameraDescription>? cameras;

  //카메라 권한
  bool isCameraGranted = false;
  //기본 수치 값
  double currentScale = 1.0;
  double currentZoomLevel = 1.0;
  double currentExposureOffset = 0.0;
  //기본 수치의 변경 가능 범위
  double minAvailableZoom = 1.0;
  double maxAvailableZoom = 1.0;
  double minAvailableExposureOffset = 0.0;
  double maxAvailableExposureOffset = 0.0;
  double baseScale = 1.0;
  //화면 위 사용자의 손가락의 개수를 확인하기 위한 Count 변수
  int points = 0;
  //해상도 프리셋
  final resolutionPreset = ResolutionPreset.values;

  ///현재 설정된 카메라의 정보를 초기화하는 비동기 함수
  Future<void> resetCamera() async {
    currentZoomLevel = 1.0;
    currentScale = 1.0;
    currentExposureOffset = 0.0;
  }

  ///카메라 권한 여부에 따라 상태를 분기하는 비동기 함수
  Future<void> allowPermission() async {
    await Permission.camera.request();

    var cameraStatus = await Permission.camera.status;

    if (cameraStatus.isGranted) {
      setState(() => isCameraGranted = true);
      //TODO: 새로운 카메라 지정. 캡처링 이미지 새로고침
    } else {
      //TODO: 에러 처리하고 다시 카메라 권한을 받을 수 있도록 해야함
    }
  }

  ///카메라 초기화 비동기 함수
  Future<void> initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController initialCameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    cameraController = initialCameraController;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
    final CameraController? controller = cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (appLifecycleState == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (appLifecycleState == AppLifecycleState.resumed) {
      initializeCameraController(cameraController!.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: const Placeholder(),
      ),
    );
  }
}
