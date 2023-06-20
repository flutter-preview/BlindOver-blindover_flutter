import 'dart:io';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:blindover_flutter/screens/camera_preview_screen.dart';
import 'package:blindover_flutter/widgets/large_action_button.dart';
import 'package:blindover_flutter/utilities/palette.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  ///- 사용자가 카메라 권한을 허용하고 카메라를 활성화할 수 있는지 확인하는 변수입니다.
  ///- [`isEnabled = false`]인 경우 카메라 권한을 다시 받을 수 있도록 합니다.
  ///- [`isEnabled = true`]인 경우 카메라를 생성하는 화면으로 바꿉니다.
  late bool isEnabled;
  late dynamic lottieCamera;

  ///- permission_handler에서 [`Permission.camera.status`] 값을 비동기 처리합니다.
  ///- [`cameraStatus`] 값에 따라 간단하게 상태를 분리합니다.
  Future<bool> checkPermission() async {
    var cameraStatus = await Permission.camera.status;

    if (cameraStatus.isGranted) {
      log("checkPermission: $cameraStatus");
      return true;
    } else if (cameraStatus.isDenied) {
      log("checkPermission: $cameraStatus");
      return false;
    } else if (cameraStatus.isPermanentlyDenied) {
      log("사용자 또는 시스템에서 잘못 선택되어 설정 앱으로 이동합니다.");
      await openAppSettings();
      return false;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    lottieCamera = Lottie.asset("assets/lotties/camera.json");
    super.didChangeDependencies();
  }

  void navigateScreen() {
    if (Platform.isIOS) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => CameraPreviewScreen(camera: widget.camera),
        ),
      );
    } else if (Platform.isAndroid) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPreviewScreen(camera: widget.camera),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50.0),
                const HeaderContentWidget(
                  words: "서비스를 사용하려면\n카메라 권한을 허용해야 합니다.",
                ),
                Expanded(
                  child: lottieCamera,
                ),
                const SizedBox(height: 50.0),
                LargeActionButton(
                  label: "label",
                  words: "허용하기",
                  onTap: () async {
                    await Permission.camera.request();
                    isEnabled = await checkPermission();
                    if (isEnabled) {
                      navigateScreen();
                    } else if (!isEnabled) {
                      await checkPermission();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderContentWidget extends StatelessWidget {
  const HeaderContentWidget({Key? key, this.words}) : super(key: key);

  final String? words;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: false,
      explicitChildNodes: false,
      excludeSemantics: false,
      selected: true,
      readOnly: true,
      label: words ?? "",
      child: Text(
        words ?? "",
        semanticsLabel: words,
        style: const TextStyle(
          fontFamily: "Roboto",
          fontSize: 30.0,
          fontWeight: FontWeight.w500,
          color: Palette.onSurface,
        ),
      ),
    );
  }
}
