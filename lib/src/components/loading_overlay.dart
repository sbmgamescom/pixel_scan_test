import 'dart:ui'; // Добавьте этот импорт

import 'package:flutter/material.dart';

/// Our custom fork of https://pub.dev/packages/modal_progress_hud adding a fading effect
///
/// wrapper around any widget that makes an async call to show a modal progress
/// indicator while the async call is in progress.
///
/// The progress indicator can be turned on or off using [isLoading]
///
/// The progress indicator defaults to a [CircularProgressIndicator] but can be
/// any kind of widget
///
/// The color of the modal barrier can be set using [color]
///
/// The opacity of the modal barrier can be set using color.withOpacity(0.5)
///
/// HUD=Heads Up Display
///
class LoadingOverlay extends StatefulWidget {
  final bool isLoading;
  final Color? color;
  // final Widget progressIndicator;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    // this.progressIndicator = const AppLoading(),
    this.color,
  });

  @override
  LoadingOverlayState createState() => LoadingOverlayState();
}

class LoadingOverlayState extends State<LoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _overlayVisible = false;

  @override
  void initState() {
    super.initState();
    _overlayVisible = false;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          _overlayVisible = true;
        });
      }

      if (status == AnimationStatus.dismissed) {
        setState(() {
          _overlayVisible = false;
        });
      }
    });
    if (widget.isLoading) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(LoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isLoading && widget.isLoading) {
      _controller.forward();
    }

    if (oldWidget.isLoading && !widget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(widget.child);

    if (_overlayVisible == true) {
      final modal = FadeTransition(
        opacity: _animation,
        child: Stack(
          children: <Widget>[
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: widget.color ?? Colors.black.withOpacity(0.3),
              ),
            ),
            Center(child: Text('One moment, please wait...')),
          ],
        ),
      );
      widgets.add(modal);
    }

    return Scaffold(body: Stack(children: widgets));
  }
}
