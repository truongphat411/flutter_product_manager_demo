import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_product_manager_demo/app.dart';
import 'service_locator.dart' as di;

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    di.init();
    runApp(
      const App(),
    );
  }, (error, stack) {
    debugPrint('error: $error - stack: $stack');
  });
}
