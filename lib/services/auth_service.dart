import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // REGISTER
  Future<AuthResponse> register({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // LOGIN
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  // CURRENT USER
  User? get currentUser => supabase.auth.currentUser;

  // STREAM (listen perubahan auth)
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;
}
