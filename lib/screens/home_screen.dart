import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

import '../app/app_color.dart';
import '../model/icons.dart';
import '../model/intent.dart';
import '../model/key.dart';
import '../model/key_character_map.dart';
import '../model/text.dart';
import '../widgets/keyboard_key.dart';
import '../widgets/text_display.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late FocusNode focusNode;
  Map<ShortcutActivator, Intent> shortcuts = {};
  Map<Type, Action<Intent>> actions = {};
  Widget padding = const SizedBox(height: 5);
  bool isShiftLeftPressed = false;
  bool isShiftRightPressed = false;
  bool isCapsLockPressed = false;
  late Timer capsLockTimer;
  List<Type> specialIntents = [
    IntentKeyShiftLeft,
    IntentKeyShiftRight,
    IntentKeyControlLeft,
    IntentKeyControlRight,
    IntentKeyAltLeft,
    IntentKeyAltRight,
  ];
  List<String> specialKeys = [
    'Shift Left',
    'Shift Right',
    'Control Left',
    'Control Right',
    'Alt Left',
    'Alt Right',
    'Caps Lock',
    'Backspace',
    'Super',
    'Context Menu',
    'Num Lock',
    'F1',
    'F2',
    'F3',
    'F4',
    'F5',
    'F6',
    'F7',
    'F8',
    'F9',
    'F10',
    'F11',
    'F12',
    'Escape'
  ];
  List<String> previousKeys = [];
  late TextModel textData;
  String lastShiftSide = 'Left';
  bool isKeyboardVisible = false;
  double keyboardHeight = 0.0;
  double keyboardOpacity = 0.0;
  Duration keyboardHeightDuration = const Duration(milliseconds: 300);
  Duration keyboardOpacityDuration = const Duration(milliseconds: 500);
  double timerIconTurns = 1;

  /// Check whether the debug name of the `KeyEvent` and the provided Key name matches
  bool isSameKey(KeyEvent keyEvent, String name) {
    return (keyEvent.logicalKey.keyLabel == name);
  }

  @override
  void initState() {
    try {
      /// The `TextModel` that handles all correct and incorrect inputs and scores
      textData = TextModel();
      textData.callback = () {
        setState(() {});
      };

      for (int i = 0; i < allKeys.length; i++) {
        for (int j = 0; j < allKeys[i].keyActivator!.length; j++) {
          /// Multiple characters can trigger the same key. For example, `a` and `A` triggers the same key
          shortcuts[allKeys[i].keyActivator![j]] = allIntents[i];
        }
      }

      for (int i = 0; i < allIntents.length; i++) {
        if (!specialIntents.contains(allIntents[i].runtimeType)) {
          actions[allIntents[i].runtimeType] = CallbackAction(onInvoke: (_) {
            /// Press Animation
            allKeys[i].firstCallback();

            /// Release Animation after a delay
            Future.delayed(
              const Duration(milliseconds: 50),
              allKeys[i].secondCallback,
            );
            return null;
          });
        } else {
          /// Empty callback for keys that cannot repeat, especially control character keys
          actions[allIntents[i].runtimeType] = CallbackAction(onInvoke: (_) {
            return null;
          });
        }
      }

      /// Logic for input updation, control characters and more...
      focusNode = FocusNode(
        canRequestFocus: true,
        onKeyEvent: (node, keyEvent) {
          if (keyEvent is KeyUpEvent) {
            /// Keypress Animation callback for all special character keys
            if (isSameKey(keyEvent, 'Shift Left')) {
              isShiftLeftPressed = false;
              allKeys[41].secondCallback();
            } else if (isSameKey(keyEvent, 'Shift Right')) {
              isShiftRightPressed = false;
              allKeys[52].secondCallback();
            } else if (isSameKey(keyEvent, 'Control Left')) {
              allKeys[53].secondCallback();
            } else if (isSameKey(keyEvent, 'Control Right')) {
              allKeys[57].secondCallback();
            } else if (isSameKey(keyEvent, 'Alt Left')) {
              allKeys[54].secondCallback();
            } else if (isSameKey(keyEvent, 'Alt Right')) {
              allKeys[56].secondCallback();
            } else if (isSameKey(keyEvent, 'Caps Lock')) {
              allKeys[27].secondCallback();
            } else if (isSameKey(keyEvent, 'Backspace')) {
              allKeys[13].secondCallback();
            }
          } else if ((keyEvent is KeyDownEvent) ||
              (keyEvent is KeyRepeatEvent)) {
            /// KeyRelease Animation Callback

            if (keyEvent is KeyDownEvent) {
              if (isSameKey(keyEvent, 'Shift Left')) {
                isShiftLeftPressed = true;
                lastShiftSide = 'Left';
                allKeys[41].firstCallback();
              } else if (isSameKey(keyEvent, 'Shift Right')) {
                isShiftRightPressed = true;
                lastShiftSide = 'Right';
                allKeys[52].firstCallback();
              } else if (isSameKey(keyEvent, 'Control Left')) {
                allKeys[53].firstCallback();
              } else if (isSameKey(keyEvent, 'Control Right')) {
                allKeys[57].firstCallback();
              } else if (isSameKey(keyEvent, 'Alt Left')) {
                allKeys[54].firstCallback();
              } else if (isSameKey(keyEvent, 'Alt Right')) {
                allKeys[56].firstCallback();
              } else if (isSameKey(keyEvent, 'Caps Lock')) {
                allKeys[27].firstCallback();
                setState(() {
                  isCapsLockPressed = !isCapsLockPressed;
                });
              }
            }
            if (!specialKeys.contains(keyEvent.logicalKey.keyLabel) &&
                (textData.totalText.length != textData.inputText.length)) {
              String expectedCharacter =
                  textData.totalText[textData.inputText.length];
              String inputCharacter = keyEvent.logicalKey.keyLabel;
              if (keyCharacterMap.keys.contains(keyEvent.logicalKey.keyLabel)) {
                inputCharacter = keyCharacterMap[keyEvent.logicalKey.keyLabel]![
                    isShiftLeftPressed || isShiftRightPressed]!;
              }
              KeyModel? inputKeyModel;
              for (var keyData in allKeys) {
                if (inputCharacter == ' ') {
                  if (keyData.character == ' ') {
                    inputKeyModel = keyData;
                    break;
                  }
                }
                if (keyData.character == inputCharacter.toUpperCase()) {
                  inputKeyModel = keyData;
                  break;
                }
              }
              if (inputKeyModel != null) {
                if (expectedCharacter == inputCharacter) {
                  if ((inputCharacter == inputCharacter.toUpperCase()) &&
                      (inputCharacter != ' ')) {
                    if (lastShiftSide == 'Left') {
                      allKeys[41].correctCount++;
                    } else {
                      allKeys[52].correctCount++;
                    }
                  }
                  inputKeyModel.correctCount++;
                } else {
                  KeyModel? expectedKeyModel;
                  for (var keyData in allKeys) {
                    if (expectedCharacter == ' ') {
                      if (keyData.character == ' ') {
                        expectedKeyModel = keyData;
                        break;
                      }
                    } else if (expectedCharacter == '\n') {
                      if (keyData.secondCharacter == '\n') {
                        expectedKeyModel = keyData;
                        break;
                      }
                    }
                    if ((keyData.character.toLowerCase() ==
                            expectedCharacter) ||
                        (keyData.character == expectedCharacter)) {
                      expectedKeyModel = keyData;
                      break;
                    }
                  }
                  expectedKeyModel!.mistakeCount++;
                  inputKeyModel.mistakeCount++;
                }
              }
              setState(() {
                if (isCapsLockPressed &&
                    !isShiftLeftPressed &&
                    !isShiftRightPressed) {
                  textData.inputText += inputCharacter.toUpperCase();
                } else if (!isCapsLockPressed &&
                    (isShiftLeftPressed || isShiftRightPressed)) {
                  textData.inputText += inputCharacter.toUpperCase();
                } else if (isCapsLockPressed &&
                    (isShiftLeftPressed || isShiftRightPressed)) {
                  textData.inputText += inputCharacter.toLowerCase();
                } else {
                  textData.inputText += inputCharacter;
                }
                textData.characterCount++;
              });
            } else {
              if ((keyEvent.logicalKey.keyLabel == 'Backspace') &&
                  (textData.inputText.isNotEmpty)) {
                if (textData.totalText[textData.inputText.length - 1] !=
                    textData.inputText[textData.inputText.length - 1]) {
                  allKeys[13].correctCount++;
                } else {
                  allKeys[13].mistakeCount++;
                }
                setState(() {
                  textData.inputText = textData.inputText
                      .substring(0, textData.inputText.length - 1);
                });
                allKeys[13].firstCallback();
              }
            }
          }

          /// This will enable all other listeners to handle the KeyEvent.
          /// Otherwise, there will not be any response from keystrokes after this.
          return KeyEventResult.ignored;
        },
      );
      focusNode.requestFocus();
      if (HardwareKeyboard.instance.lockModesEnabled
          .contains(KeyboardLockMode.capsLock)) {
        isCapsLockPressed = true;
      }
      capsLockTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
        final isCaps = HardwareKeyboard.instance.lockModesEnabled
            .contains(KeyboardLockMode.capsLock);
        if (isCaps != isCapsLockPressed) {
          setState(() {
            isCapsLockPressed = isCaps;
          });
        }
      });
    } catch (exception) {
      // ignore: avoid_print
      print(exception);
    }
    super.initState();
  }

  @override
  void dispose() {
    capsLockTimer.cancel();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.main,
      body: AnimatedContainer(
        height: h,
        width: w,
        duration: const Duration(milliseconds: 100),
        color: AppColor.main,
        child: FocusableActionDetector(
          focusNode: focusNode,
          onFocusChange: (value) {
            if (!value) {
              focusNode.requestFocus();
            }
          },
          autofocus: true,
          shortcuts: shortcuts,
          actions: actions,
          child: SizedBox(
            height: h,
            width: w,
            child: FittedBox(
              child: Column(
                children: [
                  SizedBox(height: h / 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Material(
                          color: textData.isTimerRunning
                              ? Colors.lightGreen
                              : AppColor.contrast.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox.square(
                              dimension: 45,
                              child: FittedBox(
                                child: AnimatedRotation(
                                  onEnd: () {
                                    if (textData.isTimerRunning) {
                                      if (timerIconTurns != 1) {
                                        setState(() {
                                          timerIconTurns = 1;
                                        });
                                      } else {
                                        setState(() {
                                          timerIconTurns = 2;
                                        });
                                      }
                                    }
                                  },
                                  turns: textData.isTimerRunning
                                      ? timerIconTurns
                                      : 0,
                                  duration: const Duration(milliseconds: 500),
                                  child: Icon(
                                    textData.isTimerRunning
                                        ? Icons.timer
                                        : Icons.timer_off,
                                    color: textData.isTimerRunning
                                        ? AppColor.light
                                        : AppColor.contrast.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff7272ff),
                        ),
                        child: AnimatedFlipCounter(
                          duration: const Duration(milliseconds: 300),
                          value: textData.wordsPerMinute,
                          fractionDigits: 2,
                          textStyle: const TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 30,
                            color: AppColor.light,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'WORDS PER',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              color: AppColor.contrast,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'MINUTE',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 16,
                              color: AppColor.contrast,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Material(
                          color: AppColor.contrast.withOpacity(0.1),
                          child: InkWell(
                            onTap: () {
                              AppColor.switcher(ThemeSwitchMode.change);
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox.square(
                                dimension: 45,
                                child: FittedBox(
                                  child: Icon(
                                    AppColor.isDarkMode
                                        ? Icons.brightness_low
                                        : Icons.brightness_2_rounded,
                                    color: AppColor.contrast.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: h * 0.5,
                    width: w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            height: h * 0.4,
                            width: w * 0.1,
                            child: FittedBox(
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: h * 0.06),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 50),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: isCapsLockPressed
                                            ? Colors.green
                                            : AppColor.contrast
                                                .withOpacity(0.1),
                                      ),
                                      padding: const EdgeInsets.all(10.0),
                                      child: SizedBox.square(
                                        dimension: 25,
                                        child: FittedBox(
                                          child: Text(
                                              isCapsLockPressed
                                                  ? 'CAPS'
                                                  : 'caps',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'JetBrainsMono',
                                                  fontWeight: FontWeight.bold,
                                                  color: isCapsLockPressed
                                                      ? AppColor.main
                                                      : AppColor.contrast
                                                          .withOpacity(0.7))),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Material(
                                        color:
                                            AppColor.contrast.withOpacity(0.1),
                                        child: InkWell(
                                          onTap: () {
                                            textData.resetStatistics();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: SizedBox.square(
                                              dimension: 25,
                                              child: Icon(
                                                Icons.restart_alt_rounded,
                                                color: AppColor.contrast
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Material(
                                        color:
                                            AppColor.contrast.withOpacity(0.1),
                                        child: InkWell(
                                          onTap: () {
                                            if (isKeyboardVisible) {
                                              setState(() {
                                                keyboardOpacity = 0.0;
                                                Future.delayed(
                                                    keyboardOpacityDuration,
                                                    () {
                                                  setState(() {
                                                    keyboardHeight = 0.0;
                                                    Future.delayed(
                                                        keyboardHeightDuration,
                                                        () {
                                                      setState(() {
                                                        isKeyboardVisible =
                                                            !isKeyboardVisible;
                                                      });
                                                    });
                                                  });
                                                });
                                              });
                                            } else {
                                              setState(() {
                                                isKeyboardVisible =
                                                    !isKeyboardVisible;
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 20), () {
                                                  setState(() {
                                                    keyboardHeight = h * 0.4;
                                                    Future.delayed(
                                                        keyboardHeightDuration,
                                                        () {
                                                      setState(() {
                                                        keyboardOpacity = 1.0;
                                                      });
                                                    });
                                                  });
                                                });
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: SizedBox.square(
                                              dimension: 25,
                                              child: Icon(
                                                isKeyboardVisible
                                                    ? Icons.keyboard_alt
                                                    : Icons
                                                        .keyboard_alt_outlined,
                                                color: AppColor.contrast
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(
                          width: w * 0.8,
                          child: FittedBox(
                              child: Center(
                                  child: TextDisplay(textData: textData))),
                        ),
                        SizedBox(
                          height: h * 0.4,
                          width: w * 0.1,
                          child: FittedBox(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: h * 0.06),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                    child: Material(
                                      color: AppColor.contrast.withOpacity(0.1),
                                      child: InkWell(
                                        onTap: () {
                                          textData.increaseWordCount();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SizedBox.square(
                                            dimension: 25,
                                            child: SvgPicture.string(
                                              AppIcons.add,
                                              color: AppColor.contrast
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        bottom: Radius.circular(15)),
                                    child: Material(
                                      color: AppColor.contrast.withOpacity(0.1),
                                      child: InkWell(
                                        onTap: () {
                                          textData.decreaseWordCount();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SizedBox.square(
                                            dimension: 25,
                                            child: SvgPicture.string(
                                              AppIcons.subtract,
                                              color: AppColor.contrast
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isKeyboardVisible)
                    AnimatedOpacity(
                      opacity: keyboardOpacity,
                      duration: keyboardOpacityDuration,
                      child: AnimatedContainer(
                        duration: keyboardHeightDuration,
                        height: keyboardHeight,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColor.chooser(
                                      AppColor.contrast.withOpacity(0.1),
                                      AppColor.contrast.withOpacity(0.07)),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 30,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        for (int i = 0; i < 14; i++)
                                          KeyboardKeyWidget(keyData: allKeys[i])
                                      ],
                                    ),
                                    padding,
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                for (int i = 14; i < 27; i++)
                                                  KeyboardKeyWidget(
                                                      keyData: allKeys[i])
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                for (int i = 27; i < 40; i++)
                                                  KeyboardKeyWidget(
                                                      keyData: allKeys[i])
                                              ],
                                            ),
                                          ],
                                        ),
                                        KeyboardKeyWidget(keyData: allKeys[40]),
                                      ],
                                    ),
                                    padding,
                                    Row(
                                      children: [
                                        for (int i = 41; i < 53; i++)
                                          KeyboardKeyWidget(keyData: allKeys[i])
                                      ],
                                    ),
                                    padding,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        for (int i = 53; i < 58; i++)
                                          KeyboardKeyWidget(keyData: allKeys[i])
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
