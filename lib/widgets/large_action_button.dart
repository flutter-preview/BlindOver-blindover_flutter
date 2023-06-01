import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:blindover_flutter/utilities/palette.dart';

///- `LageActionButton()` 위젯은 Stateless 위젯을 상속받습니다.
///- Constraint 형식의 큰 버튼으로 디바이스에서 최대 크기로 나타납니다.
class LargeActionButton extends StatelessWidget {
  ///- String 값을 할당하면, Semantic 위젯에서 이를 처리할 수 있습니다.
  final String label;

  ///- String 값을 할당해서 버튼의 역할을 시각화합니다.
  final String words;

  ///- 함수를 할당하면 사용자의 액션을 감지하고 처리할 수 있습니다.
  ///- 예외적으로 함수를 할당하지 않고 null 처리가 가능합니다.
  final VoidCallback? onTap;

  const LargeActionButton({
    Key? key,
    required this.label,
    required this.words,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: true,
      container: false,
      explicitChildNodes: false,
      excludeSemantics: false,
      label: label,
      onTap: onTap,
      child: Platform.isIOS
          ? CupertinoButton(
              onPressed: onTap,
              color: Palette.secondaryContainer,
              child: Text(
                words,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            )
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.secondaryContainer,
                elevation: 2.0,
              ),
              child: Text(
                words,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
    );
  }
}
