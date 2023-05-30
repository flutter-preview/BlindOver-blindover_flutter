import 'dart:io';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:blindover_flutter/permission_screen.dart';

List<CameraDescription> cameras = <CameraDescription>[];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    log("카메라 연결에 실패했습니다.\n자세한 내용:[${e.code}: ${e.description}]");
  }
  runApp(const MainApp());
}

///- `MainApp()`: 애플리케이션의 최상위 위젯 역할을 수행합니다.
///- iOS와 Android 플랫폼을 지원합니다. [`Platform.isIOS`, `Platform.isAndroid`]
class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Builder() 위젯을 사용해서 BuildContext를 캡쳐하고, 이를 하위 위젯 트리에 전달합니다.
    return Builder(
      /// Builder() 위젯의 `builder: [Widget Function(BuildContext)]` 인수는 null일 수 없습니다.
      builder: (context) {
        /// 타겟 플랫폼이 iOS라면 쿠퍼티노 디자인의 scaffold를 빌드합니다.
        if (Platform.isIOS) {
          return const CupertinoApp(
            home: CupertinoPageScaffold(
              child: PermissionScreen(),
            ),
          );

          /// 타겟 플랫폼이 AOS라면 머티리얼 디자인의 scaffold를 빌드합니다.
        } else if (Platform.isAndroid) {
          return const MaterialApp(
            home: Scaffold(
              body: PermissionScreen(),
            ),
          );
        }
        return const Scaffold();
      },
    );
  }
}
