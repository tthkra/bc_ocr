import 'package:flutter/material.dart';
import 'info_display.dart';
import 'scan_img.dart';
import 'utils/classify_text.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<MyHomePage> {
  final GlobalKey<InfoCardState> infoCardKey = GlobalKey();
  final GlobalKey<InfoTileState> infoTileKey = GlobalKey();
  late final InfoProcessor processor;

  @override
  void initState() {
    super.initState();
    processor = InfoProcessor(infoCardKey: infoCardKey, infoTileKey: infoTileKey);
  }

  void resetState() {
    infoCardKey.currentState?.resetState();
    infoTileKey.currentState?.resetState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
      ),
      body:
      ListView(
        children: [
          ScannedImg(processor: processor , onReset: resetState),
          InfoCard(key: infoCardKey),
          InfoTile(key: infoTileKey),
        ],
      ),
    );
  }
}
