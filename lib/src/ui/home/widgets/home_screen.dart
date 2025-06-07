import 'package:flutter/material.dart';
import 'package:pixel_scan_test/src/components/loading_overlay.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: true,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Hello World!'), SizedBox(height: 50)],
          ),
        ),
      ),
    );
  }
}
