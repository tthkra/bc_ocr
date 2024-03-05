import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'process_input.dart';
import '/info_display.dart';
import 'package:flutter/material.dart';


Future<String> runModel(String text) async {
  const int maxLength = 50;
  late tfl.Interpreter interpreter;
  try {
    interpreter = await tfl.Interpreter.fromAsset('assets/model.tflite');
    print("Model loaded successfully");
  } catch (e) {
    print("Failed to load the model: $e");
    return 'Error';
  }

  List<int> processedInput = await modelInputProcessor.tokenizeAndPad(text, maxLength);
  int sequenceLength = 50;

  if (processedInput.length > sequenceLength) {
    processedInput = processedInput.sublist(0, sequenceLength);
  } else {
    while (processedInput.length < sequenceLength) {
      processedInput.add(0);
    }
  }

  List<double> floatInput = processedInput.map((i) => i.toDouble()).toList();

// Create model's input tensor
  List<List<double>> inputTensor = [floatInput];

  var outputTensor = List.generate(1, (_) => List<double>.filled(1, 0.0));

// Run model's inference
  try {
    interpreter.run(inputTensor, outputTensor);
  } catch (e) {
    print("Error during model inference: $e");
  }

  double predictionValue = outputTensor[0][0];

  interpreter.close();

  return predictionValue > 0.5 ? 'POS' : 'O';
}


class InfoProcessor {

  final GlobalKey<InfoCardState> infoCardKey;
  final GlobalKey<InfoTileState> infoTileKey;

  InfoProcessor({required this.infoCardKey , required this.infoTileKey});

  Future<void> processTextArray(List<String> textLines) async {
    Map<String, String?> details = {
      'name': null,
      'position': null,
      'description': null,
      'description2': null,
      'phoneNumber': null,
      'phoneNumber2': null,
      'email': null,
      'address': null,
      'url': null,
    };

    // List<String> containsOnlyEnglish(List<String> textLines) {
    //   RegExp pattern = RegExp(r'[^\x00-\x7F]+');
    //   return textLines.where((line) => !pattern.hasMatch(line)).toList();
    // }
    //
    // List<String> filterNonEnglish(List<String> textLines) {
    //   return textLines.where((line) => containsOnlyEnglish(line)).toList();
    // }
    //   // Filter out non english text
    //   textLines = filterNonEnglish(textLines);
    // print(textLines);


    List<bool> usedLines = List<bool>.filled(textLines.length, false);

    // Initialize entity extractor
    final entityExtractor = EntityExtractor(
        language: EntityExtractorLanguage.english);


    for (int i = 0; i < textLines.length; i++) {
      String line = textLines[i];
      String classification = await runModel(line);

      if (classification == "POS") {
        details['position'] = line;
        usedLines[i] = true;

        if (i > 0) {
          details['name'] = textLines[i - 1];
          usedLines[i-1] = true;
        }
        print('ur safe girl');
        break;
      }
    }



    for (int i = 0; i < textLines.length; i++) {
      String line = textLines[i];
      final List<EntityAnnotation> annotations = await entityExtractor
          .annotateText(line);

      for (final annotation in annotations) {
        final text = annotation
            .text;

        for (final entity in annotation.entities) {
          switch (entity.type) {
            case EntityType.address:
              if (details['address'] == null) {
                details['address'] = text;
                usedLines[i] = true;
              }
            case EntityType.phone:
              if (text != null && text.length >= 7) {
                if (details['phoneNumber'] == null) {
                  details['phoneNumber'] = text;
                  usedLines[i] = true;
                } else {
                  details['phoneNumber2'] = text;
                  usedLines[i] = true;
                }
              }
              break;
            case EntityType.email:
              if (details['email'] == null) {
                details['email'] = text;
                usedLines[i] = true;
              }
              break;
            case EntityType.url:
              if (details['url'] == null) {
                details['url'] = text;
                usedLines[i] = true;
              }
              break;
            case EntityType.unknown:
            default:
              break;
          }
        }
      }
    }

    //process additional info
    for (int i = 0; i < textLines.length; i++) {
      if (!usedLines[i]) {
        List<String> words = textLines[i].split(RegExp(r'\s+'));

        if (words.length >= 4) {
          if (details['description2'] == null) {
            details['description2'] = textLines[i];
            usedLines[i] = true;
            break;
          }
        }
      }
    }

    //process additional info
    for (int i = 0; i < textLines.length; i++) {
      if (!usedLines[i]) {
        List<String> words = textLines[i].split(RegExp(r'\s+'));

        if (words.length <= 4) {
          if (details['description'] == null) {
            details['description'] = textLines[i];
            usedLines[i] = true;
            break;
          }
        }
      }
    }

    details.forEach((key, value) {
      if (value == null || value.isEmpty) {
        details[key] = "";
      }
    });

    entityExtractor.close();
    if (infoCardKey.currentState != null) {
      infoCardKey.currentState!.updateInfo(details['name'], details['position'], details['description'] , details['description2']);
    }
    if (infoTileKey.currentState != null) {
      infoTileKey.currentState!.updateInfo(details['phoneNumber'], details['phoneNumber2'], details['address'], details['email'], details['url']);
    }
  }
}