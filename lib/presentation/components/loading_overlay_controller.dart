import 'package:flutter/material.dart';

class LoadingOverlayController {
  static final LoadingOverlayController _instance =
      LoadingOverlayController._internal();
  factory LoadingOverlayController() => _instance;
  LoadingOverlayController._internal();

  static LoadingOverlayController get instance => _instance;

  OverlayEntry? _overlayEntry;

  void show(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          const ModalBarrier(
            dismissible: false,
          ),
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 100),
              builder: (context, value, child) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void hide() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }
}
