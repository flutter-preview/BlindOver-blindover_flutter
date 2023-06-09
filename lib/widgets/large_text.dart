import 'package:flutter/material.dart';

///- [LargeText] 위젯은 [Semantics] 위젯으로 구성됩니다.
///- Talkback 또는 VoiceOver가 활성화된 상태에서 사용자는 음성으로 글자를 들을 수 있습니다.
class LargeText extends StatefulWidget {
  final String words;

  const LargeText({
    Key? key,
    required this.words,
  }) : super(key: key);

  @override
  State<LargeText> createState() => _LargeTextState();
}

class _LargeTextState extends State<LargeText> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: true,
      container: false,
      explicitChildNodes: false,
      excludeSemantics: false,
      label: widget.words,
      child: Center(
        child: Text(
          widget.words,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
