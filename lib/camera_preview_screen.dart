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

  // 해상도 설정
  final myResolutionPreset = ResolutionPreset.medium;

  ///현재 설정된 카메라의 정보를 초기화하는 비동기 함수
  Future<void> resetCamera() async {
    currentZoomLevel = 1.0;
    currentScale = 1.0;
    currentExposureOffset = 0.0;
  }

  // ///카메라 초기화 비동기 함수
  // Future<void> initializeCameraController(
  //     CameraDescription cameraDescription) async {
  //   final CameraController cameraController = CameraController(
  //     cameraDescription,
  //     ResolutionPreset.medium,
  //     imageFormatGroup: ImageFormatGroup.jpeg,
  //   );
  //   _cameraController = cameraController;

  //   cameraController.addListener(() {
  //     if (mounted) {
  //       setState(() {});
  //     }
  //     if (cameraController.value.hasError) {
  //       SnackBar(
  //         content: const Text("카메라 연결에 실패했습니다."),
  //         action: SnackBarAction(
  //           label: "확인",
  //           onPressed: () {},
  //         ),
  //       );
  //       log("카메라 오류: ${cameraController.value.errorDescription}");
  //     }
  //   });

  //   try {
  //     await cameraController.initialize();
  //     await Future.wait(
  //       [
  //         cameraController
  //             .getMaxZoomLevel()
  //             .then((double value) => maxAvailableZoom = value),
  //         cameraController
  //             .getMaxZoomLevel()
  //             .then((double value) => minAvailableZoom = value),
  //       ],
  //     );
  //   } on CameraException catch (e) {
  //     switch (e.code) {
  //       case "CameraAccessDenied":
  //         log("카메라 접근이 거부되었습니다.");
  //         break;
  //       case "CameraAccessDeniedWithoutPrompt":
  //         log("카메라 접근이 거부되었습니다. 설정에서 카메라 권한을 허용해야 합니다.");
  //         break;
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // 상위 위젯으로부터 받은 카메라 정보로 카메라 컨트롤러를 초기화합니다.
    _cameraController = CameraController(
      widget.camera,
      myResolutionPreset,
    );
    // 카메라 컨트롤러를 초기화합니다. 이는 Future를 반환합니다.
    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    // 카메라 위젯으로부터 받은 카메라 정보를 해제합니다.
    _cameraController.dispose();
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
  //   final CameraController? cameraController = _cameraController;

  //   if (cameraController == null || !cameraController.value.isInitialized) {
  //     return;
  //   }

  //   if (appLifecycleState == AppLifecycleState.inactive) {
  //     cameraController.dispose();
  //   } else if (appLifecycleState == AppLifecycleState.resumed) {
  //     initializeCameraController(_cameraController!.description);
  //   }
  // }

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
                      // TODO: 스캔 버튼 눌렀을 때 서버에 이미지를 전송하는 코드 작성해야함
                    },
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
