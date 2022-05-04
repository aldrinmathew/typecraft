/// These are keys of characters that are case sensitive, but are not handled
/// by flutter
///
/// Basically pressing shift enables the user to enter the alternative character
/// of a physical key. For other keys, Flutter automatically detects those as
/// separate keys, but for the following characters, it has to be handled
/// manually
Map<String, Map<bool, String>> keyCharacterMap = {
  'Tab': {false: '\t', true: '\t'},
  'Q': {false: 'q', true: 'Q'},
  'W': {false: 'w', true: 'W'},
  'E': {false: 'e', true: 'E'},
  'R': {false: 'r', true: 'R'},
  'T': {false: 't', true: 'T'},
  'Y': {false: 'y', true: 'Y'},
  'U': {false: 'u', true: 'U'},
  'I': {false: 'i', true: 'I'},
  'O': {false: 'o', true: 'O'},
  'P': {false: 'p', true: 'P'},
  'Enter': {false: '\n', true: '\n'},
  'A': {false: 'a', true: 'A'},
  'S': {false: 's', true: 'S'},
  'D': {false: 'd', true: 'D'},
  'F': {false: 'f', true: 'F'},
  'G': {false: 'g', true: 'G'},
  'H': {false: 'h', true: 'H'},
  'J': {false: 'j', true: 'J'},
  'K': {false: 'k', true: 'K'},
  'L': {false: 'l', true: 'L'},
  'Z': {false: 'z', true: 'Z'},
  'X': {false: 'x', true: 'X'},
  'C': {false: 'c', true: 'C'},
  'V': {false: 'v', true: 'V'},
  'B': {false: 'b', true: 'B'},
  'N': {false: 'n', true: 'N'},
  'M': {false: 'm', true: 'M'},
  ' ': {false: ' ', true: ' '},
};
