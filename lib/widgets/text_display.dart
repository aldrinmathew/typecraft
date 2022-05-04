import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/app_color.dart';
import '../model/icons.dart';
import '../model/text.dart';

class TextDisplay extends StatefulWidget {
  const TextDisplay({
    Key? key,
    required this.textData,
  }) : super(key: key);

  final TextModel textData;

  @override
  _TextDisplayState createState() => _TextDisplayState();
}

class _TextDisplayState extends State<TextDisplay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.textData.callback = () {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < widget.textData.textList.length - 1; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int j = 0; j < widget.textData.textList[i].length; j++)
                    SingleCharacter(
                      lineIndex: i,
                      characterIndex: j,
                      textData: widget.textData,
                    )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class SingleCharacter extends StatefulWidget {
  const SingleCharacter({
    Key? key,
    required this.lineIndex,
    required this.characterIndex,
    required this.textData,
  }) : super(key: key);

  final int lineIndex;
  final int characterIndex;
  final TextModel textData;

  @override
  _SingleCharacterState createState() => _SingleCharacterState();
}

class _SingleCharacterState extends State<SingleCharacter> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: AppColor.chooser(500, 300)),
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
          color: ((widget.textData.previousLinesCharacters(widget.lineIndex) +
                      widget.characterIndex) <
                  widget.textData.inputText.length)
              ? (widget.textData.isSameCharacter(
                      (widget.textData.previousLinesCharacters(widget.lineIndex) +
                          widget.characterIndex))
                  ? Colors.green.withOpacity(AppColor.chooser(0.3, 0.5))
                  : Colors.red.withOpacity(AppColor.chooser(0.3, 0.5)))
              : ((widget.textData.previousLinesCharacters(widget.lineIndex) +
                          widget.characterIndex ==
                      widget.textData.inputText.length)
                  ? AppColor.extremeDark
                  : Colors.transparent),
          borderRadius: (widget.characterIndex == 0)
              ? const BorderRadius.horizontal(left: Radius.circular(6))
              : ((widget.characterIndex == widget.textData.textList[widget.lineIndex].length - 1)
                  ? const BorderRadius.horizontal(right: Radius.circular(6))
                  : const BorderRadius.only())),
      child: ((widget.textData.textList[widget.lineIndex]
                      [widget.characterIndex] ==
                  ' ') ||
              ((widget.textData.textList[widget.lineIndex]
                      [widget.characterIndex] ==
                  '\n')))
          ? SizedBox(
              height: 33,
              width: 25,
              child: FittedBox(
                child: Opacity(
                  opacity: (widget.textData
                                  .previousLinesCharacters(widget.lineIndex) +
                              widget.characterIndex <
                          widget.textData.inputText.length)
                      ? 0.7
                      : ((widget.textData.previousLinesCharacters(
                                      widget.lineIndex) +
                                  widget.characterIndex ==
                              widget.textData.inputText.length)
                          ? 1.0
                          : 0.2),
                  child: SvgPicture.string(
                    (widget.textData.textList[widget.lineIndex]
                                [widget.characterIndex] ==
                            ' ')
                        ? ((widget.textData.previousLinesCharacters(
                                        widget.lineIndex) +
                                    widget.characterIndex ==
                                widget.textData.inputText.length)
                            ? AppColor.chooser(
                                AppIcons.spaceDark, AppIcons.space)
                            : AppColor.chooser(
                                AppIcons.space, AppIcons.spaceDark))
                        : ((widget.textData.previousLinesCharacters(
                                        widget.lineIndex) +
                                    widget.characterIndex ==
                                widget.textData.inputText.length)
                            ? AppColor.chooser(
                                AppIcons.newlineDark, AppIcons.newline)
                            : AppColor.chooser(
                                AppIcons.newline, AppIcons.newlineDark)),
                  ),
                ),
              ),
            )
          : Text(
              widget.textData.textList[widget.lineIndex][widget.characterIndex],
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'FiraCode',
                fontWeight: FontWeight.bold,
                color: (widget.textData
                                .previousLinesCharacters(widget.lineIndex) +
                            widget.characterIndex <
                        widget.textData.inputText.length)
                    ? AppColor.extremeDark
                    : ((widget.textData
                                    .previousLinesCharacters(widget.lineIndex) +
                                widget.characterIndex ==
                            widget.textData.inputText.length)
                        ? AppColor.extremeLight
                        : AppColor.contrast.withOpacity(0.7)),
              ),
            ),
    );
  }
}
