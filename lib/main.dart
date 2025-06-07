import 'package:flutter/material.dart';
import 'package:pixel_scan_test/src/ui/pdf/widgets/pdf_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PdfScreen(),
    );
  }
}
