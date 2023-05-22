## Deployment

### 1. 프로젝트를 직접 다운로드 받고 실행하는 과정
1. Flutter SDK 버전을 확인합니다.

```bash
#실행
flutter --version
flutter doctor -v

#결과
[✓] Flutter (Channel stable, 3.10.0, on macOS 13.4 22F66 darwin-arm64, locale en-KR)
    • ...
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.2)
    • ...
[✓] Xcode - develop for iOS and macOS (Xcode 14.3)
    • ...
[✓] Chrome - develop for the web
    • ...
[✓] Android Studio (version 2022.1)
    • ...
[✓] VS Code (version 1.78.2)
    • ...
[✓] Connected device (3 available)
    • ...
[✓] Network resources
    • ...

• No issues found!
```

2. 코드 분석을 진행합니다.

```bash
#실행
flutter analyze

#결과
Analyzing blindover_flutter...                                          
No issues found! (ran in 1.2s)
```
3. Debug 또는 Release 모드로 Flutter 에뮬레이터로 실행합니다.

```bash
#실행
flutter devices
flutter run -d flutter_emulator
flutter run

#결과
...
Started application in 320ms.
```

## Color Reference
> 손쉬운 사용과 관련된 색상은 Color within Constraints 자료를 참고했습니다.

- [Color within Constraints](https://medium.com/tap-to-dismiss/color-within-constraints-d6f777a3b72d)

## App design with Figma
> 어플리케이션 디자인은 피그마 도구로 진행했습니다.

- [BlindOver Drafts](https://www.figma.com/file/b000qyAOCnQBksXJBEerSA/BlindOver?type=design&node-id=0%3A1&t=KcVHyzelcjBuW4Tn-1)