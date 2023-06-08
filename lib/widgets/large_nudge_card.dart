import 'package:flutter/material.dart';

/// [LargeNudgeCard] 위젯은 [LargeText] 위젯을 감싸는 위젯입니다.
class LargeNudgeCard extends StatelessWidget {
  final Color? containerColor;
  final double? width;
  final double? height;
  final Widget child;

  const LargeNudgeCard({
    Key? key,
    this.containerColor,
    this.width,
    this.height,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 100.0,
      height: height ?? 55.0,
      decoration: BoxDecoration(
        color: containerColor ?? Colors.orangeAccent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: child,
      ),
    );
  }
}
