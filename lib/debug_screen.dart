import 'package:flutter/material.dart';

import 'package:blindover_flutter/widgets/large_action_button.dart';
import 'package:blindover_flutter/widgets/large_nudge_card.dart';
import 'package:blindover_flutter/widgets/large_text.dart';

/// [DebugScreen]은 커스텀 위젯을 디버깅하기 위한 화면입니다.
/// 에뮬레이터 또는 시뮬레이터로 앱을 디버깅할 때 사용합니다.
class DebugScreen extends StatelessWidget {
  const DebugScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: const LargeNudgeCard(
            width: double.infinity,
            height: 100.0,
            child: LargeText(words: "카메라 화면"),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              LargeActionButton(
                label: "촬영버튼",
                words: "촬영하기",
                onTap: () => (),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
