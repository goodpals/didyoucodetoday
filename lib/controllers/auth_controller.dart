import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:didyoucodetoday/models/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends Cubit<AppAuthState> {
  AuthController() : super(AppAuthState()) {
    init();
  }

  final supabase = Supabase.instance.client;

  void init() {
    supabase.auth.onAuthStateChange.listen((data) {
      if (data.session?.user != state.user) {
        emit(AppAuthState(user: data.session?.user));
      }
    });
  }

  @override
  void emit(AppAuthState state) {
    super.emit(state);
    if (state.user != null && state.profile == null) {
      _getProfile(state.user!);
    }
  }

  void loginGithub() async {
    await supabase.auth.signInWithOAuth(
      Provider.github,
      redirectTo:
          kDebugMode ? null : 'https://goodpals.github.io/didyoucodetoday/',
      // redirectTo: kIsWeb ? null : 'io.supabase.flutter://callback',
    );
  }

  void logout() async {
    await supabase.auth.signOut();
  }

  Future<void> _getProfile(User user) async {
    final resp = await supabase.from('profiles').select().eq('id', user.id);
    if (resp.isNotEmpty) {
      final profile = Profile.fromJson(resp.first);
      if (state.user != user) return;
      emit(state.copyWith(profile: profile));
      return;
    }
    final profile = Profile(
        username: user.userMetadata?['preferred_username'] ??
            user.email?.split('@').first ??
            'Unknown User');
    await supabase.from('profiles').insert(
      {
        'id': user.id,
        ...profile.toJson(),
      },
    );
    if (state.user == user) {
      emit(state.copyWith(profile: profile));
    }
  }
}

// there is a supabase class called AuthState
class AppAuthState {
  final User? user;
  final Profile? profile;

  bool get loggedIn => user != null;
  bool get complete => user != null && profile != null;

  AppAuthState({this.user, this.profile});

  AppAuthState copyWith({
    User? user,
    Profile? profile,
  }) {
    return AppAuthState(
      user: user ?? this.user,
      profile: profile ?? this.profile,
    );
  }
}
