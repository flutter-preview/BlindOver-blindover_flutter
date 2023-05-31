import 'dart:developer';

import 'package:blindover_flutter/utilities/palette.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:blindover_flutter/preview_screen.dart';
import 'package:blindover_flutter/widgets/constraint_large_button.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  final String lottieCamera = "assets/lotties/camera.json";

  @override
  void initState() {
    super.initState();
  }

  Future<bool> requestCameraPermission() async {
    var cameraStatus = await Permission.camera.status;

    if (cameraStatus.isGranted) {
      log("requestCameraPermission: $cameraStatus");
      return true;
    } else if (cameraStatus.isDenied) {
      log("requestCameraPermission: $cameraStatus");
      return false;
    } else if (cameraStatus.isPermanentlyDenied) {
      log("사용자 또는 시스템에서 잘못 선택된 경우 설정으로 바로 이동하도록 유도합니다.");
      await openAppSettings();
      return false;
    }
    return false;
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
                  words: "서비스를 사용하려면 카메라 권한을 허용해야 합니다.",
                ),
                Expanded(
                  child: Lottie.asset(lottieCamera),
                ),
                const SizedBox(height: 50.0),
                ConstraintLargeButton(
                  label: "label",
                  value: "허용하기",
                  onTap: () async {
                    await Permission.camera.request();
                    await requestCameraPermission();
                    if (requestCameraPermission == true) {
                      log("true");
                    } else if (requestCameraPermission == false) {
                      log("false");
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
          fontSize: 25.0,
          fontWeight: FontWeight.w300,
          color: Palette.onSurface,
        ),
      ),
    );
  }
}
