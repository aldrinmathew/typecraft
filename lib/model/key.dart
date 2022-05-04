// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyModel {
  KeyModel({
    required this.character,
    this.secondCharacter,
    this.height,
    this.width,
    this.keyActivator,
  })  : correctCount = 0,
        mistakeCount = 0 {
    if (keyActivator == null) {
      if (secondCharacter != null) {
        keyActivator = [];
        keyActivator!.addAll([
          CharacterActivator(character),
          CharacterActivator(secondCharacter!)
        ]);
      } else {
        keyActivator = [];
        keyActivator!.add(CharacterActivator(character));
      }
    }
  }
  String character;
  String? secondCharacter;
  VoidCallback firstCallback = () {};
  VoidCallback secondCallback = () {};
  double? height;
  double? width;
  int correctCount;
  int mistakeCount;
  List<ShortcutActivator>? keyActivator;
  double get accuracy {
    if ((mistakeCount + correctCount) == 0) {
      return 0;
    } else {
      return (correctCount) / (mistakeCount + correctCount);
    }
  }
}

List<KeyModel> allKeys = [
  KeyModel(character: '`', secondCharacter: '~'),
  KeyModel(character: '1', secondCharacter: '!'),
  KeyModel(character: '2', secondCharacter: '@'),
  KeyModel(character: '3', secondCharacter: '#'),
  KeyModel(character: '4', secondCharacter: '\$'),
  KeyModel(character: '5', secondCharacter: '%'),
  KeyModel(character: '6', secondCharacter: '^'),
  KeyModel(character: '7', secondCharacter: '&'),
  KeyModel(character: '8', secondCharacter: '*'),
  KeyModel(character: '9', secondCharacter: '('),
  KeyModel(character: '0', secondCharacter: ')'),
  KeyModel(character: '-', secondCharacter: '_'),
  KeyModel(character: '=', secondCharacter: '+'),
  KeyModel(
    character: 'Backspace',
    width: 100,
    keyActivator: [LogicalKeySet(LogicalKeyboardKey.backspace)],
  ),
  KeyModel(
    character: 'Tab',
    width: 70,
    keyActivator: [LogicalKeySet(LogicalKeyboardKey.tab)],
  ),
  KeyModel(
    character: 'Q',
    keyActivator: [
      const CharacterActivator('q'),
      const CharacterActivator('Q')
    ],
  ),
  KeyModel(
    character: 'W',
    keyActivator: [
      const CharacterActivator('w'),
      const CharacterActivator('W')
    ],
  ),
  KeyModel(
    character: 'E',
    keyActivator: [
      const CharacterActivator('e'),
      const CharacterActivator('E')
    ],
  ),
  KeyModel(
    character: 'R',
    keyActivator: [
      const CharacterActivator('r'),
      const CharacterActivator('R')
    ],
  ),
  KeyModel(
    character: 'T',
    keyActivator: [
      const CharacterActivator('t'),
      const CharacterActivator('T')
    ],
  ),
  KeyModel(
    character: 'Y',
    keyActivator: [
      const CharacterActivator('y'),
      const CharacterActivator('Y')
    ],
  ),
  KeyModel(
    character: 'U',
    keyActivator: [
      const CharacterActivator('u'),
      const CharacterActivator('U')
    ],
  ),
  KeyModel(
    character: 'I',
    keyActivator: [
      const CharacterActivator('i'),
      const CharacterActivator('I')
    ],
  ),
  KeyModel(
    character: 'O',
    keyActivator: [
      const CharacterActivator('o'),
      const CharacterActivator('O')
    ],
  ),
  KeyModel(
    character: 'P',
    keyActivator: [
      const CharacterActivator('p'),
      const CharacterActivator('P')
    ],
  ),
  KeyModel(character: '[', secondCharacter: '{'),
  KeyModel(character: ']', secondCharacter: '}'),
  KeyModel(
    character: 'Caps',
    width: 70,
    keyActivator: [LogicalKeySet(LogicalKeyboardKey.capsLock)],
  ),
  KeyModel(
    character: 'A',
    keyActivator: [
      const CharacterActivator('a'),
      const CharacterActivator('A')
    ],
  ),
  KeyModel(
    character: 'S',
    keyActivator: [
      const CharacterActivator('s'),
      const CharacterActivator('S')
    ],
  ),
  KeyModel(
    character: 'D',
    keyActivator: [
      const CharacterActivator('d'),
      const CharacterActivator('D')
    ],
  ),
  KeyModel(
    character: 'F',
    keyActivator: [
      const CharacterActivator('f'),
      const CharacterActivator('F')
    ],
  ),
  KeyModel(
    character: 'G',
    keyActivator: [
      const CharacterActivator('g'),
      const CharacterActivator('G')
    ],
  ),
  KeyModel(
    character: 'H',
    keyActivator: [
      const CharacterActivator('h'),
      const CharacterActivator('H')
    ],
  ),
  KeyModel(
    character: 'J',
    keyActivator: [
      const CharacterActivator('j'),
      const CharacterActivator('J')
    ],
  ),
  KeyModel(
    character: 'K',
    keyActivator: [
      const CharacterActivator('k'),
      const CharacterActivator('K')
    ],
  ),
  KeyModel(
    character: 'L',
    keyActivator: [
      const CharacterActivator('l'),
      const CharacterActivator('L')
    ],
  ),
  KeyModel(character: ';', secondCharacter: ':'),
  KeyModel(character: '\'', secondCharacter: '"'),
  KeyModel(character: '\\', secondCharacter: '|'),
  KeyModel(
    character: 'Enter',
    secondCharacter: '\n',
    width: 80,
    height: 115,
    keyActivator: [LogicalKeySet(LogicalKeyboardKey.enter)],
  ),
  KeyModel(
    character: 'Shift',
    width: 132,
    keyActivator: [LogicalKeySet(LogicalKeyboardKey.shiftLeft)],
  ),
  KeyModel(
    character: 'Z',
    keyActivator: [
      const CharacterActivator('z'),
      const CharacterActivator('Z')
    ],
  ),
  KeyModel(
    character: 'X',
    keyActivator: [
      const CharacterActivator('x'),
      const CharacterActivator('X')
    ],
  ),
  KeyModel(
    character: 'C',
    keyActivator: [
      const CharacterActivator('c'),
      const CharacterActivator('C')
    ],
  ),
  KeyModel(
    character: 'V',
    keyActivator: [
      const CharacterActivator('v'),
      const CharacterActivator('V')
    ],
  ),
  KeyModel(
    character: 'B',
    keyActivator: [
      const CharacterActivator('b'),
      const CharacterActivator('B')
    ],
  ),
  KeyModel(
    character: 'N',
    keyActivator: [
      const CharacterActivator('n'),
      const CharacterActivator('N')
    ],
  ),
  KeyModel(
    character: 'M',
    keyActivator: [
      const CharacterActivator('m'),
      const CharacterActivator('M')
    ],
  ),
  KeyModel(character: ',', secondCharacter: '<'),
  KeyModel(character: '.', secondCharacter: '>'),
  KeyModel(character: '/', secondCharacter: '?'),
  KeyModel(
    character: 'Shift',
    width: 132,
    keyActivator: [LogicalKeySet(LogicalKeyboardKey.shiftRight)],
  ),
  KeyModel(
    character: 'Ctrl',
    width: 110,
    keyActivator: [LogicalKeySet(LogicalKeyboardKey.controlLeft)],
  ),
  KeyModel(
    character: 'Alt',
    width: 85,
    keyActivator: [LogicalKeySet(LogicalKeyboardKey.altLeft)],
  ),
  KeyModel(
    character: ' ',
    width: 430,
    keyActivator: [LogicalKeySet(LogicalKeyboardKey.space)],
  ),
  KeyModel(
    character: 'Alt',
    width: 85,
    keyActivator: [LogicalKeySet(LogicalKeyboardKey.altRight)],
  ),
  KeyModel(
    character: 'Ctrl',
    width: 110,
    keyActivator: [LogicalKeySet(LogicalKeyboardKey.controlRight)],
  ),
];
