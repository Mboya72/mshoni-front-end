import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

Future<void> main() async {
  // 1. Required for any async setup before the app starts
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Supabase with your Project credentials
  await Supabase.initialize(
    url: 'https://qkzxfbrilyzoayhbpjib.supabase.com', // Found in Supabase -> Settings -> API
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFrenhmYnJpbHl6b2F5aGJwamliIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIyMjI5NjksImV4cCI6MjA4Nzc5ODk2OX0.79gng2o8Ym-DYFtd78gTHXNWQ3HhiN81MlS0cvnXtQ0', // Found in Supabase -> Settings -> API
  );

  runApp(const App());
}