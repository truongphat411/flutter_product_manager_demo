import 'package:flutter/material.dart';

class CommonDialog {
  static final CommonDialog _instance = CommonDialog._internal();
  factory CommonDialog() => _instance;
  CommonDialog._internal();

  static CommonDialog get instance => _instance;

  OverlayEntry? _overlayEntry;

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void show({
    required BuildContext context,
    required String content,
    required String contentYes,
    String? contentNo,
    required VoidCallback onYes,
    VoidCallback? onNo,
  }) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black54,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(content, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (contentNo != null)
                        TextButton(
                          onPressed: () {
                            hide();
                          },
                          child: Text(contentNo),
                        ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          hide();
                          onYes();
                        },
                        child: Text(contentYes),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }
}
