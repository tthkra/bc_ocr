import 'package:flutter/material.dart';
import 'home_page.dart';
import 'utils/process_input.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await modelInputProcessor.loadVocabulary();
  await modelInputProcessor.loadVocabulary2();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
