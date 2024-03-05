// ignore_for_file: avoid_print, prefer_const_constructors, unused_label

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'utils/classify_text.dart';
import 'utils/modal_selector.dart';



class ScannedImg extends StatefulWidget {
  final InfoProcessor processor;
  final VoidCallback onReset;

  ScannedImg({Key? key, required this.processor, required this.onReset}) : super(key: key);

  @override
  _ScannedImgState createState() => _ScannedImgState();
}

class _ScannedImgState extends State<ScannedImg> {
  String _text = '';
  File? _pickedImg;
  final ImagePicker _imagePicker = ImagePicker();
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<void> pickImage(ImageSource? source) async {
    try {
      final getImage = await _imagePicker.pickImage(source: source!);
      if (getImage != null) {
        setState(() {
          _pickedImg = File(getImage.path);
        });

        final inputImage = InputImage.fromFilePath(getImage.path);
        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

        List<String> extractedTexts = [];
        for (TextBlock block in recognizedText.blocks) {
          for (TextLine line in block.lines) {
            extractedTexts.add(line.text);
          }
        }
        print(extractedTexts);
        widget.processor.processTextArray(extractedTexts);

      }
    } catch (e) {
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.grey[300],
      child: Stack(
        children: [
          if (_pickedImg == null)
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  minimumSize: Size.fromHeight(250),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 100, color: Colors.grey[400]),
                    Icon(Icons.add, size: 90, color: Colors.grey[400]),
                  ],
                ),
                onPressed: () {
                  imagePickerModal(
                    context,
                    onCameraTap: () async {
                      Navigator.pop(context);
                      await pickImage(ImageSource.camera);
                    },
                    onGalleryTap: () async {
                      Navigator.pop(context);
                      await pickImage(ImageSource.gallery);
                    },
                  );
                },
              ),
            ),
          if (_pickedImg != null) ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                  image: FileImage(_pickedImg!),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red, size: 30),
                      onPressed: () {
                        setState(() {
                          _pickedImg = null;
                          _text = '';
                        });
                        widget.onReset();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}




