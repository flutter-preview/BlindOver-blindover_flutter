import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:blindover_flutter/preview_screen.dart';
import 'package:blindover_flutter/widgets/constraint_large_button.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  void initState() {
    super.initState();
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
                headerContentWidget(),
                bodyContentWidget(),
                const SizedBox(height: 50.0),
                ConstraintLargeButton(
                  label: "label",
                  value: "허용하기",
                  onTap: requestCameraPermission,

                  // onTap: () async {
                  //   requestCameraPermission;
                  //   await Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => const PreviewScreen(),
                  //     ),
                  //   );
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerContentWidget() {
    return const Expanded(
      child: Text("서비스 사용을 위해 카메라 권한을 허용해야합니다."),
    );
  }

  Widget bodyContentWidget() {
    return Expanded(
      child: Lottie.asset(
        "assets/lotties/camera.json",
        fit: BoxFit.fill,
      ),
    );
  }

  Future<void> requestCameraPermission() async {
    final permissionStatus = await Permission.camera.request();

    if (permissionStatus == PermissionStatus.granted) {
      log("카메라 권한을 허용함.");
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PreviewScreen(),
        ),
      );
    } else if (permissionStatus == PermissionStatus.denied) {
      log("카메라 권한을 허용하지 않음.");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
  }
}
