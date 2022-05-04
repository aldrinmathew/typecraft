// ignore_for_file: prefer_function_declarations_over_variables
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'constants.dart';
import 'words.dart';

class TextModel {
  List<String> _textList = [];

  String _totalText = '';

  String get totalText => _totalText;

  String _inputText = '';

  int _numberOfWords = 8;

  bool capital = true;

  int characterCount = 0;

  final Stopwatch _stopwatch = Stopwatch();

  bool get isTimerRunning => _stopwatch.isRunning;

  void Function() callback = () {};

  SharedPreferences? preferences;

  List<String> get textList => _textList;

  String get inputText => _inputText;

  int previousRuntime = 0;

  double get wordsPerMinute {
    if ((previousRuntime + _stopwatch.elapsedMilliseconds) != 0) {
      double newWPM = (characterCount / 5) / (((previousRuntime + _stopwatch.elapsedMilliseconds) / 1000) / 60);
      return newWPM;
    } else {
      return 0;
    }
  }

  set inputText(String value) {
    if ((_inputText == '') && (!_stopwatch.isRunning)) {
      _stopwatch.start();
    }
    _inputText = value;
    if ((value.length == totalText.length) &&
        (_totalText[_inputText.length - 1] == _inputText[_inputText.length - 1])) {
      _inputText = '';
      stopTimer();
      getText();
    }
  }

  TextModel() {
    syncData();
  }

  void syncData() async {
    preferences = await SharedPreferences.getInstance();
    int? cacheCharacterCount = preferences!.getInt(characterCountKey);
    double? cacheRuntime = preferences!.getDouble(timeTakenKey);
    int? cacheWordCount = preferences!.getInt(wordCountKey);
    if (cacheCharacterCount == null) {
      preferences!.setInt(characterCountKey, 0);
    }
    characterCount = cacheCharacterCount ?? 0;
    if (cacheRuntime == null) {
      preferences!.setDouble(timeTakenKey, 0);
    }
    previousRuntime = ((cacheRuntime ?? 0) * 10000).truncate();
    if (cacheWordCount == null) {
      preferences!.setInt(wordCountKey, 8);
    }
    _numberOfWords = cacheWordCount ?? 8;
    getText();
  }

  bool isSameCharacter(int index) {
    return (totalText[index] == inputText[index]);
  }

  int previousLinesCharacters(int index) {
    int result = 0;
    for (int i = 0; i < index; i++) {
      result += textList[i].length;
    }
    return result;
  }

  void increaseWordCount() {
    if (_numberOfWords < 30) {
      _numberOfWords += 4;
      preferences!.setInt(wordCountKey, _numberOfWords);
      _inputText = '';
      stopTimer();
      getText();
      callback();
    }
  }

  void decreaseWordCount() {
    if (_numberOfWords >= 8) {
      _numberOfWords -= 4;
      preferences!.setInt(wordCountKey, _numberOfWords);
      _inputText = '';
      stopTimer();
      getText();
      callback();
    }
  }

  void resetStatistics() {
    _stopwatch.stop();
    _stopwatch.reset();
    if (preferences != null) {
      preferences!.setInt(characterCountKey, 0);
      preferences!.setDouble(timeTakenKey, 0);
    }
    previousRuntime = 0;
    characterCount = 0;
    getText();
    callback();
  }

  void stopTimer() {
    if (preferences != null) {
      preferences!.setInt(characterCountKey, characterCount);
      preferences!.setDouble(timeTakenKey, (previousRuntime + _stopwatch.elapsedMilliseconds) / 10000);
    }
    _stopwatch.stop();
  }

  /// Gets new text to be displayed by `TextDisplay`
  void getText() {
    List<String> returnList = [];
    Random random = Random();
    for (int i = 0; i < _numberOfWords; i++) {
      String word = words[random.nextInt(words.length)];
      while (word.length > 7) {
        word = words[random.nextInt(words.length)];
      }
      if (capital) {
        returnList.add(word[0].toUpperCase() + word.substring(1));
      } else {
        returnList.add(word);
      }
    }
    int length = returnList.length;
    int factor = length ~/ 4;
    List<String> cacheList = returnList;
    int insertedCount = 0;
    for (int i = factor; i <= length; i += factor) {
      for (int j = 1 + i - factor; j < i; j++) {
        cacheList.insert(j + insertedCount, ' ');
        insertedCount++;
      }
      cacheList.insert(i + insertedCount, '\n');
      insertedCount++;
      if (i != length) {
        cacheList.insert(i + insertedCount, ' ');
        insertedCount++;
      }
    }
    int lineEndingIndex = 0;
    _textList = [];
    _textList.add('');
    for (int i = 0; i < cacheList.length; i++) {
      if (cacheList[i] != '\n') {
        _textList[lineEndingIndex] += cacheList[i];
      } else {
        _textList[lineEndingIndex] += cacheList[i];
        _textList.add('');
        lineEndingIndex++;
      }
    }
    _totalText = '';
    _inputText = '';
    for (int i = 0; i < cacheList.length; i++) {
      _totalText += cacheList[i];
    }
    callback();
  }
}
