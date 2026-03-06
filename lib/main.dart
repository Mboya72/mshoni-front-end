import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

void main() async {
  // 1. Required for async initialization
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Set preferred orientations and UI overlay styles (Optional but recommended)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // 3. Launch the App
  runApp(const App());
}