import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl =
      'https://hjevqzziabgqszuthvbz.supabase.co';

  static const String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhqZXZxenppYWJncXN6dXRodmJ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEyNjg0NDAsImV4cCI6MjA3Njg0NDQ0MH0.ZAvsDiHqo1iwFu0T-smOVABQ0VLHJ-kr1nPxqfyaPp8';

  static Future<void> init() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
