import 'package:flutter/material.dart';
import 'package:trex/trex.dart';
import 'package:typecraft/app/app_color.dart';

import '../app/app_style.dart';
import '../model/key.dart';

class KeyboardKeyWidget extends StatefulWidget {
  const KeyboardKeyWidget({
    super.key,
    required this.keyData,
  });

  final KeyModel keyData;

  @override
  KeyboardKeyWidgetState createState() => KeyboardKeyWidgetState();
}

class KeyboardKeyWidgetState extends State<KeyboardKeyWidget> {
  late final Hookful<double> height;
  late final Hookful<int> duration;
  late final FocusNode focusNode;

  @override
  void initState() {
    height = Hookful((widget.keyData.height ?? 50) + 6, this);
    duration = Hookful(10, this);
    widget.keyData.firstCallback = animateForward;
    widget.keyData.secondCallback = animateBackward;
    focusNode = FocusNode(canRequestFocus: true);
    focusNode.requestFocus();
    super.initState();
  }

  void animateForward() {
    height.value = widget.keyData.height ?? 50;
    // duration.value = 50;
  }

  void animateBackward() {
    height.value = (widget.keyData.height ?? 50) + 6;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (widget.keyData.height ?? 50) + 6,
      width: widget.keyData.width ?? 50,
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: duration.value),
          // padding: EdgeInsets.only(top: (duration.value == 50) ? 0 : 7),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: duration.value),
                height: height.value,
                width: widget.keyData.width ?? 50,
                decoration: BoxDecoration(
                  color: AppColor.contrast.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: widget.keyData.height ?? 50,
                width: widget.keyData.width ?? 50,
                decoration: BoxDecoration(
                  color: AppColor.main,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.keyData.character,
                            style: AppStyle.letter.copyWith(
                              fontSize: (widget.keyData.character.length > 1)
                                  ? ((widget.keyData.secondCharacter != null)
                                      ? 14
                                      : 17)
                                  : 22,
                              color: AppColor.contrast
                                  .withOpacity(AppColor.chooser(1, 0.7)),
                            ),
                          ),
                        ),
                        if (widget.keyData.secondCharacter != null)
                          const SizedBox(width: 8),
                        if (widget.keyData.secondCharacter != null)
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              widget.keyData.secondCharacter!,
                              style: AppStyle.letter.copyWith(
                                color: AppColor.contrast.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 2),
                      width: (widget.keyData.width ?? 50) - 20,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: (widget.keyData.correctCount == 0 &&
                                widget.keyData.mistakeCount == 0)
                            ? AppColor.contrast.withOpacity(0.3)
                            : Color.lerp(
                                Colors.red,
                                Colors.green,
                                widget.keyData.accuracy,
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
