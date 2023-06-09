import 'dart:io';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class PictureController {
  Future<String> getTemporaryPicturePath() async {
    final directory = await getTemporaryDirectory();
    return "${directory.path}/picture.jpg";
  }

  /// 메모리를 낭비하지 않고 효율적으로 사진을 저장하도록 [picture.saveTo] 메서드를 사용합니다.
  Future<void> takePictureToTemporaryFile(XFile picture) async {
    final temporaryFilePath = await getTemporaryPicturePath();
    try {
      await picture.saveTo(temporaryFilePath);
    } catch (e) {
      log("사진을 임시 저장하는데 실패했습니다.$e");
    }
  }

  Future<void> deletePreviousPicture() async {
    final temporaryFilePath = await getTemporaryPicturePath();
    final file = File(temporaryFilePath);
    if (file.existsSync()) {
      try {
        await file.delete();
      } catch (e) {
        log("이전 사진을 삭제하는데 실패했습니다.$e");
      }
    }
  }
}
