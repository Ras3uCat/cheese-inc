import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/app_env.dart';

/// SupabaseService — initializes the Supabase client from AppEnv credentials.
/// Access the client anywhere via SupabaseService.client.
class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client => Supabase.instance.client;

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (AppEnv.supabaseUrl.isEmpty || AppEnv.supabaseAnonKey.isEmpty) return;
    try {
      await Supabase.initialize(
        url: AppEnv.supabaseUrl,
        anonKey: AppEnv.supabaseAnonKey,
      ).timeout(const Duration(seconds: 8));
      _initialized = true;
    } catch (_) {
      // Project unreachable or paused — app continues in demo-data mode.
    }
  }

  static bool get isConfigured => _initialized;

  // Auth convenience
  static User? get currentUser => client.auth.currentUser;
  static Session? get currentSession => client.auth.currentSession;
  static bool get isSignedIn => currentUser != null;

  static Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}
