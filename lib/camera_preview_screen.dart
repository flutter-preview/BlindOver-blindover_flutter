import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';

import 'package:blindover_flutter/widgets/large_action_button.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen>
    with WidgetsBindingObserver {
  /// 카메라 컨트롤러
  late CameraController _cameraController;

  /// 카메라 초기화 비동기 함수
  late Future<void> _initializeCameraControllerFuture;

  /// 카메라의 정보를 설정하는 변수
  List<CameraDescription>? cameras;

  /// 기본 수치 값
  double currentScale = 1.0;

  /// 포인트 마다 카메라 Zoom In/Out 변경 값
  double currentZoomLevel = 1.0;

  /// 카메라 노출 범위 기본 값
  double currentExposureOffset = 0.0;

  /// 최소로 변경 가능한 Zoom In/Out 값
  double minAvailableZoom = 1.0;

  /// 최대로 변경 가능한 Zoom In/Out 값
  double maxAvailableZoom = 1.0;

  /// 최소로 변경 가능한 노출 범위 값
  double minAvailableExposureOffset = 0.0;

  /// 최대로 변경 가능한 노출 범위 값
  double maxAvailableExposureOffset = 0.0;

  /// 카메라 해상도 설정
  final myResolutionPreset = ResolutionPreset.medium;

  /// 현재 설정된 카메라의 정보를 초기화하는 비동기 함수
  Future<void> resetCamera() async {
    currentZoomLevel = 1.0;
    currentScale = 1.0;
    currentExposureOffset = 0.0;
  }

  @override
  void initState() {
    super.initState();

    /// 상위 위젯으로부터 받은 카메라 정보로 카메라 컨트롤러를 초기화합니다.
    _cameraController = CameraController(
      widget.camera,
      myResolutionPreset,
    );

    /// 카메라 컨트롤러를 초기화합니다. 이는 Future를 반환합니다.
    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    /// 카메라 위젯으로부터 받은 카메라 정보를 해제합니다.
    resetCamera();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
    final CameraController cameraController = _cameraController;

    if (!cameraController.value.isInitialized ||
        appLifecycleState == AppLifecycleState.inactive) {
      /// 앱이 비활성화되면 카메라 컨트롤러를 해제합니다.
      cameraController.dispose();
    } else if (appLifecycleState == AppLifecycleState.resumed) {
      /// 앱이 재개되면 카메라 컨트롤러를 다시 초기화합니다.
      _initializeCameraControllerFuture = _cameraController.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _initializeCameraControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              if (Platform.isIOS) {
                return const CupertinoActivityIndicator();
              } else if (Platform.isAndroid) {
                return const CircularProgressIndicator();
              }
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  const LargeActionButton(label: "이곳에 글자가 표시됩니다.", words: "-"),
                  Expanded(
                    child: CameraPreview(_cameraController),
                  ),
                  LargeActionButton(
                    label: "스캔버튼",
                    words: "스캔하기",
                    onTap: () {
                      /// TODO: 스캔 버튼 눌렀을 때 서버에 이미지를 전송하는 코드 작성해야함
                    },
                  ),
                ],
              );
            }
            return Semantics(
              child: Container(),
            );
          },
        ),
      ),
    );
  }
}
