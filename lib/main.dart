import 'dart:io';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';

import 'package:blindover_flutter/permission_screen.dart';
import 'package:blindover_flutter/camera_preview_screen.dart';
import 'package:permission_handler/permission_handler.dart';

// 사용 가능한 카메라를 검색할 수 있는 자료형을 생성합니다.
List<CameraDescription> cameras = <CameraDescription>[];

Future<void> main() async {
  try {
    // `runApp()` 앱이 호출되기 전에 초기화가 필요한 플러그인을 위해 호출합니다.
    WidgetsFlutterBinding.ensureInitialized();
    // `cameras` 리스트 자료형에 활성화 가능한 카메라를 주입합니다.
    cameras = await availableCameras();
  } on CameraException catch (e) {
    log("카메라 연결에 실패했습니다.\n내용:[${e.code}: ${e.description}]");
  }
  // `runApp()` 앱을 실행합니다. `MainApp()` 위젯은 `cameras` 리스트 자료형의 첫 번째 카메라를 인수로 받습니다.
  runApp(MainApp(camera: cameras.first));
}

///- 애플리케이션의 최상위 위젯 역할을 수행합니다.
///- iOS와 Android 플랫폼을 지원합니다. [`Platform.isIOS`, `Platform.isAndroid`]
class MainApp extends StatelessWidget {
  const MainApp({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    /// Builder() 위젯을 사용해서 BuildContext를 캡쳐하고, 이를 하위 위젯에 주입합니다.
    return Builder(
      /// Builder() 위젯의 `builder: [Widget Function(BuildContext)]` 인수는 null일 수 없습니다.
      builder: (context) {
        return MaterialApp(
          /// FutureBuilder() 위젯을 사용해서 비동기 처리를 수행합니다.
          home: FutureBuilder<PermissionStatus>(
            future: Permission.camera.status,
            builder: (context, snapshot) {
              /// 만약 스냅샷의 ConnectionState가 `waiting`이면 로딩 중임을 표시합니다.
              if (snapshot.connectionState == ConnectionState.waiting) {
                /// 플랫폼에 따라 다른 디자인의 로딩 위젯을 표시하도록 합니다.
                if (Platform.isIOS) {
                  return const CupertinoActivityIndicator();
                } else if (Platform.isAndroid) {
                  return const CircularProgressIndicator();
                }

                /// 만약 `snapshot` ConnectionState가 `done`이면 비동기 처리가 완료되었음을 표시합니다.
              } else if (snapshot.connectionState == ConnectionState.done) {
                /// 카메라 권한이 허용되었는지 조건문을 통해 확인하고, 이에 따라 앱의 상태를 분리합니다.
                if (snapshot.data!.isGranted) {
                  return CameraPreviewScreen(camera: camera);
                } else if (snapshot.data!.isDenied) {
                  return PermissionScreen(camera: cameras.first);
                } else if (snapshot.data!.isPermanentlyDenied) {
                  return PermissionScreen(camera: cameras.first);
                }
              }

              /// 실제로 실행되지 않는 코드입니다.
              /// 스냅샷의 ConnectionState가 `waiting` 또는 `done`이 아닌 경우를 처리할 때 실행됩니다.
              return PermissionScreen(camera: cameras.first);
            },
          ),
        );
      },
    );
  }
}
