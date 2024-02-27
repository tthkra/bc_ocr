import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class modelInputProcessor {
  static Map<String, int> _wordIndex = {};

  // Load model's vocabulary
  static Future<void> loadVocabulary() async {
    final jsonString = await rootBundle.loadString('assets/word_index.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _wordIndex = jsonMap.map((key, value) => MapEntry(key, value.toInt()));
  }

  // Preprocess model's input text
  static List<int> tokenizeAndPad(String text, int maxLength) {
    String processedText = text.toLowerCase();

    processedText = processedText.replaceAll(RegExp(r'[^\w\s]'), '');

    List<String> words = processedText.split(RegExp(r'\s+'));

    List<int> sequence = words.map((word) =>
    _wordIndex[word] ?? _wordIndex["<OOV>"]!).toList();

    if (sequence.length < maxLength) {
      sequence.addAll(List.filled(
          maxLength - sequence.length, 0));
    } else if (sequence.length > maxLength) {
      sequence = sequence.sublist(0, maxLength);
    }

    return sequence;
  }
}