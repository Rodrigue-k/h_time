import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _globalKey = GlobalKey();

  Future<void> _handleCapture() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));

      final RenderRepaintBoundary? boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        if (kDebugMode) {
          print('Boundary not found');
        }
        return;
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);

      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();

        // Sauvegarde dans les documents
        final directory = await getApplicationDocumentsDirectory();
        final fileName =
            'schedule_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(pngBytes);

        if (kDebugMode) {
          print('Schedule captured and saved to: ${file.path}');
        }

        // Optionnel : Afficher une notification de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Capture sauvegardée')),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during capture: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la capture')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: AppHeader(handleCapture: _handleCapture),
      ),
      body: RepaintBoundary(key: _globalKey, child: ScheduleView()),
    );
  }
}
