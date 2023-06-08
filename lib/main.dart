import 'dart:io';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:blindover_flutter/debug_screen.dart';
import 'package:blindover_flutter/permission_screen.dart';
import 'package:blindover_flutter/camera_preview_screen.dart';

///- [CameraDescription]은 카메라의 정보를 담고 있습니다.
///- 사용 가능한 카메라를 주입할 수 있도록 [CameraDescription] 유형의 리스트 [cameras]를 생성합니다.
List<CameraDescription> cameras = <CameraDescription>[];

Future<void> main() async {
  try {
    /// [runApp] 호출되기 이전에 초기화가 필요한 플러그인을 먼저 호출합니다.
    WidgetsFlutterBinding.ensureInitialized();

    /// [cameras] 리스트 자료형에 활성화 가능한 카메라를 주입합니다.
    cameras = await availableCameras();
  } on CameraException catch (e) {
    log("카메라 연결에 실패했습니다.\n내용:[${e.code}: ${e.description}]");
  }

  /// 카메라가 주입되지 않은 경우 디버그 화면을 출력합니다.
  /// 카메라가 주입되지 않은 경우는 시뮬레이터에서 실행하거나 앱이 디버그 모드인 경우입니다.
  cameras.isEmpty
      ? runApp(const DebugScreen())
      : runApp(MainApp(camera: cameras.first));
}

///- 앱의 메인 위젯 역할을 수행합니다.
///- 앱의 상태를 분리하기 위해 [FutureBuilder]을 사용합니다.
class MainApp extends StatelessWidget {
  const MainApp({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    /// [Builder] 위젯을 사용해서 [BuildContext]를 캡쳐하고, 이를 하위 위젯 트리에 주입합니다.
    return Builder(
      builder: (context) {
        return MaterialApp(
          home: FutureBuilder<PermissionStatus>(
            future: Permission.camera.status,
            builder: (context, snapshot) {
              /// [snapshot.connectionState]가 [waiting]이면 로딩 중임을 표시합니다.
              if (snapshot.connectionState == ConnectionState.waiting) {
                /// 플랫폼에 따라 다른 디자인의 로딩 위젯을 표시하도록 합니다.
                return Platform.isAndroid
                    ? const CircularProgressIndicator()
                    : const CupertinoActivityIndicator();
              }

              /// [snapshot.connectionState]가 [done]이면 비동기 처리가 완료되었음을 표시합니다.
              if (snapshot.connectionState == ConnectionState.done) {
                /// 카메라 권한이 허용되었는지 조건문을 통해 확인하고, 이에 따라 앱의 상태를 분리합니다.
                return snapshot.data!.isGranted
                    ? CameraPreviewScreen(camera: camera)
                    : PermissionScreen(camera: cameras.first);
              }

              /// 실제로는 실행되지 않는 코드입니다.
              /// [snapshot.connectionState]가 [waiting] 또는 [done]이 아닌 경우일 때 실행될 수 있습니다.
              return PermissionScreen(camera: cameras.first);
            },
          ),
        );
      },
    );
  }
}
